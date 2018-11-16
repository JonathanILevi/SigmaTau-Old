module galactic_.logic_world_.entities_.entity_;
import commonImports;

import loose_.vec_math_;
public import galactic_msg_	.galactic_msg_	: NetEntity = Entity;

enum EntityType {
	starSystem	,
	sun	,
	planet	,
	asteroid	,
	ship	,
}


interface  EntityMaster {
	void onAddedFlatEntity(FlatEntity);
	void onRemovedFlatEntity(FlatEntity);
}

abstract class Entity : EntityMaster{
	abstract @property EntityType type();
	this(float[2] pos=[0,0], float ori=0) {
		this.pos	= pos	;
		this.ori	= ori	;
		callSubInits;
	}
	void update() {
		callSubUpdates;
		foreach (entity; nestedEntities) 
			entity.update;
	}
	////abstract void init();
	abstract protected void callSubInits();
	abstract protected void callSubUpdates();
	private Entity[]	_nestedEntities	= [];
	private FlatEntity[]	_nestedFlatEntities	= [];
	@property Entity[] nestedEntities() {
		return _nestedEntities~[];	// Shallow copy the array, so that only the data in the `Entity` will be affected.
			// It would be far better to just pass an const(headconst(Entity)[]) but D does not support this.
	}
	@property FlatEntity[] nestedFlatEntities() {
		return _nestedFlatEntities~[];	// Shallow copy the array, so that only the data in the `Entity` will be affected.
			// It would be far better to just pass an const(headconst(Entity)[]) but D does not support this.
	}
	void addEntity(E)(E entity) if(!isAbstractClass!E) {
		entity.master = this;
		_nestedEntities~=entity;
		static if (is(E:FlatEntity)) {
			_nestedFlatEntities ~= entity;
			onAddedFlatEntity(entity);
		}
	}
	void removeEntity(E)(E entity) if(!isAbstractClass!E) {
		_nestedEntities = _nestedEntities.remove(_nestedEntities.countUntil(entity));
		static if (is(E:FlatEntity)) {
			_nestedFlatEntities = _nestedFlatEntities.remove(_nestedFlatEntities.countUntil(entity));
			onRemovedFlatEntity(entity);
		}
		entity.master = null;
	}
	
	EntityMaster	master	;// Set by master's addEntity;
	
	public {
		/**	Called when entity is added/removed to world.
			A Call to this function will propagate through nested entities.
			Sets `inWorld` on each entity in the tree.
			Passes flat entities to the now known world.
		*/
		void addedToWorld() {
			assert(!(master is null));
			this.inWorld = true;
			nestedFlatEntities.each!(a=>master.onAddedFlatEntity(a));
			nestedEntities.each!(a=>a.addedToWorld);
		}
		/// Ditto
		void removedFromWorld() {
			assert(!(master is null));
			nestedFlatEntities.each!(a=>master.onRemovedFlatEntity(a));
			nestedEntities.each!(a=>a.removedFromWorld);
			this.inWorld = false;
		}
		/**	Call with propagate through the masters.
			Used to inform world when a flat entity is added/removed.
			Is called whenever a flat entity is added/removed (using `addEntity`/`removeEntity).
				Is also called when entity tree is added to world because
				world will not have recieved past calls.
		*/
		void onAddedFlatEntity(FlatEntity entity) {
			if (!(master is null)) {
				master.onAddedFlatEntity(entity);
			} 
		}
		/// Ditto
		void onRemovedFlatEntity(FlatEntity entity) {
			master.onRemovedFlatEntity(entity);
		}
	}
	
	@property {
		abstract protected {
			float[2]	virtualPos();
			void	virtualPos(float[2]);
			float	virtualOri();
			void	virtualOri(float);
		}
		float[2]	pos()	{ return virtualPos	; }
		void	pos(float[2] n)	{ virtualPos(n)	; }
		float	ori()	{ return virtualOri	; }
		void	ori(float n)	{ virtualOri(n)	; }
	}
			
	bool	inWorld	= false	; // Changed in `world.addEntity` and `.removeEntity`
}

abstract class FlatEntity : Entity {
	this(float[2] pos=[0,0],float ori=0) {
		super(pos,ori);
	}
	public {
		NetEntity!true	netEntity	= new NetEntity!true;
	}
	protected override @property {
		float[2]	virtualPos()	{ return netEntity.pos	; }
		void	virtualPos(float[2] n)	{ netEntity.pos = n	; }
		float	virtualOri()	{ return netEntity.ori	; }
		void	virtualOri(float n)	{ netEntity.ori = n	; }
	}
	
	void update_netEntity() {
		log(true,netEntity._networkVar_0_changed);
		netEntity.networkVar_update((msg){msg.log;}, []);
	}
}


























