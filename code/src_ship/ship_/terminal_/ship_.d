module ship_.terminal_.ship_;
import commonImports;

static import terminal_msg_.up_;

import ship_.world_	.world_	:	World	;
import ship_.terminal_	.terminal_network_	:	TerminalNetwork	;
import ship_.terminal_	.components_	;

class Ship {
	this(World world) {
		this.world	= world	;
		this.addComponent(ComponentType.metaRadar);
		this.addComponent(ComponentType.metaMove);
	}
	const(ubyte[])[] update(TerminalNetwork[] newTerminals) {
		terminals ~= newTerminals;
		//---Send to new
		foreach (term; newTerminals) {
			import terminal_msg_.down_ship_;
			auto msg = ComponentsMsg();
			msg.components = this.componentTypes;
			term.send(msg);
		}
		//---Get msgs
		foreach (term; this.terminals) {
			import terminal_msg_.up_;
			foreach (unknownMsg; term.map!(msgData=>UnknownMsg(msgData))) {
				unknownMsg.msgData.log;
				if (unknownMsg.component==ubyte.max) {
					onMsg(unknownMsg, term);
				}
				else {
					if (unknownMsg.component >= this.components.length) {
						log("msg from terminal is asking for a component that does not exist");
					}
					else {
						if (this.components[unknownMsg.component] is null){
							final switch (this.componentTypes[unknownMsg.component]) {
								case ComponentType.metaRadar:
									this.components[unknownMsg.component] = new MetaRadar(unknownMsg.component, this.world, null);
									break;
								case ComponentType.metaMove:
									this.components[unknownMsg.component] = new MetaMove(unknownMsg.component, this.world, null);
									break;
							}
						}
						this.components[unknownMsg.component].onMsg(unknownMsg, term);
					}
				}
			}
		}
		foreach (component; components) {
			if (!(component is null)) {
				component.update();
			}
		}
		{
			////import galactic_msg_.up_;
			////auto msg = new ChVelMsg;
			////msg.vel	= [0,0.1];
			////msg.anv	= 0.01;
			////return [msg];
			return [];
		}
	}
	
	
	private {
		World	world	;
		TerminalNetwork[]	terminals	=[];
		ComponentType[]	componentTypes	;
		Component[]	components	;
		
		
		void addComponent(ComponentType type) {
			assert(terminals.length==0, "cannot add components while terminal is connected");
			this.componentTypes	~=type	;
			this.components	~=null	;
		}
		
		void onMsg(terminal_msg_.up_.UnknownMsg unknownMsg, TerminalNetwork from) {
			import terminal_msg_.up_ship_;
			final switch (unknownMsg.type) {
				case MsgType.test:
					auto msg = TestMsg(unknownMsg);
					msg.testByte.log;
					msg.testArray.log;
					break;
			}
		}
	}
}

