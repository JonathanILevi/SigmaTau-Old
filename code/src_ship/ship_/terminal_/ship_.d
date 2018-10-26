module ship_.terminal_.ship_;
import commonImports;

import ship_.world_	.world_	:	World	;
import ship_.terminal_	.terminal_network_	:	TerminalNetwork	;
import ship_.terminal_	.components_	;








class Ship {
	this(World world) {
		this.world	= world	;
		this.addComponent(ComponentType.metaRadar);
		this.addComponent(ComponentType.metaMove);
	}
	
	void update(TerminalNetwork[] newTerminals) {
		//---New Terminals
		{
			terminals ~= newTerminals;
			foreach (term; newTerminals) {
				import terminal_msg_.down_ship_;
				foreach (comp; componentTypes.byKeyValue) {
					auto msg = new NewComponentMsg();
					msg.id	= comp.key	;
					msg.componentType	= comp.value	;
					term.send(msg);
				}
			}
		}
		//---
		foreach (component; components) {
			component.networkUpdate();
		}
		foreach (component; components) {
			component.update();
		}
	}
		
	private {
		World	world	;
		TerminalNetwork[]	terminals	=[];
		ComponentType[ubyte]	componentTypes	;
		ubyte	nextComponentId	=0;
		Component[]	components	;
		
		
		void addComponent(ComponentType type) {
			assert(terminals.length==0, "cannot add components while terminal is connected");
			this.componentTypes[nextComponentId++]	= type	;
		}
		Component getComponent(ubyte id) {
			void createComponent(ubyte id) {
					final switch (this.componentTypes[componentTypes[id]]) {
						case ComponentType.metaRadar:
							this.components ~= new MetaRadar(this.world, null, id);
							break;
						case ComponentType.metaMove:
							this.components ~= new MetaMove(this.world, null, id);
							break;
					}
			}
			
			
			foreach (component; components) {
				if (component.id==id) {
					return component;
				}
			}
			createComponent(id);
			return components[$-1];
		}
	}
}






