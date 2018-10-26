module ship_.terminal_.components_;
import commonImports;

public import terminal_msg_	.component_type_	:	ComponentType	;

import terminal_msg_	.protocol_;
import ship_.world_	.world_	;
import ship_.world_	.entity_	;


/*	Interface for ship used in `FunctionComponent`s
*/
interface Ship {
	
}

/*	
*/
class MetaEntity {
	mixin EntityTemplate;
	this(Entity worldEntity) {
		this.worldEntity	= worldEntity	;
		update();
	}
	void update() {
		pos	= worldEntity.pos	;
		ori	= worldEntity.ori	;
	}
	Entity	worldEntity	;
	@property bool inWorld() {
		return worldEntity.inWorld; 
	}
}


/*	Base Component Type
*/
abstract class Component {
	abstract @property ComponentType type();
	
	this(ubyte id) {
		this.id 	= id	;
	}
	void networkUpdate() {
	}
	void update() {
		
	}
	public {
		ubyte	id	;
	}
	private {
	}
}
/*	Base for Function Components
	    Function Components are components that talk to the meta game data about the world
	and convert it to the gameplay info that the terminals are locked to.  e.g. The terminal 
	code will never know their "meta game" location (the location the game logic uses); in game location
	in Sigma Tau is purely relative.
*/
abstract class FunctionComponent : Component {
	this(World world, Ship ship, ubyte id) {
		super(id);
		this.world	= world	;
		this.ship	= ship	;
	}
	override {
		final void networkUpdate() {
			updateFromGalactic();
			super.networkUpdate();
		}
		final void update() {}
	}
	abstract void updateFromGalactic();
	
	private {
		World	world	;
		Ship	ship	;
	}
}
/*	Base for Logic Components
	    Logic Components are components that do calculations purely through knowledge of other
	components.  Things like autopilot.
*/
abstract class LogicComponent : Component {
	this(ComponentType[ubyte] componentTypes, Component delegate(ubyte id) getComponent_callback, ubyte id) {
		super(id);
		this.componentTypes	= componentTypes	;
		this.getComponent_callback	= getComponent_callback	;
	}
	override {
		final void networkUpdate() {
			super.networkUpdate;
		}
		void update() {
			super.update();
		}
	}
	private {
		ComponentType[ubyte]	componentTypes	;
		Component delegate(ubyte id)	getComponent_callback	;
		
		Component getComponent(ubyte id) {
			return getComponent_callback(id);
		}
	}
}
/*	
*/
class MetaRadar : FunctionComponent {
	override @property ComponentType type() { return ComponentType.metaRadar; }
	mixin MetaRadarTemplate!MetaEntity;
	
	this(World world, Ship ship, ubyte id) {
		super(world, ship, id);
	}
	override {
		void updateFromGalactic() {
			//---Update data from galactic
			{
				foreach_reverse (i, entity; entities) {
					if (!entity.inWorld) {
						removeEntity(entity);
					}
					else {
						entity.update;
					}
				}
				//---Add new entities
				Entity[] newEntities =	entities.length>0
					? world.entities.find(entities[$-1])[1..$]
					: world.entities;
				_entities.reserve(entities.length+newEntities.length);
				foreach (i,entity; newEntities) {
					addEntity(new MetaEntity(entity));
				}
			}
		}
	}
	private {
	}
}
/*	
*/
class MetaMove : FunctionComponent {
	override @property ComponentType type() { return ComponentType.metaMove; }
	mixin MetaMoveTemplate;
	
	this(World world, Ship ship, ubyte id) {
		super(world, ship, id);
	}
	override {
		void updateFromGalactic() {
		}
	}
	private {
		
	}
}






























