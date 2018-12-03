module galactic_.logic_world_.entities_.entity_;
import commonImports;

import loose_.vec_math_;
import std.traits;
public import galactic_msg_	.galactic_msg_	: NetEntity = Entity;


abstract class EntityOwner {
	public {
		@property Entity[] entities() {
			return _entities~[];	// Shallow copy the array, so that only the data in the `Entity` will be affected.
				// It would be far better to just pass an const(headconst(Entity)[]) but D does not support this.
		}
		////@property {
		////	const(Entity[]) entities	() { return	_entities	; }
		////	const(Entity[]) addedEntities	() { return	_addedEntities	; }
		////}
		@property bool removed() {
			return _removed;
		}
	}
	package(galactic_.logic_world_) {
		void addEntity(E)(E entity) if(!isAbstractClass!E && is(E:Entity)) {
			this._entities	~=entity	;
			this._addedEntities	~= entity	;
		}
		void removeEntity(E)(E entity) if(!isAbstractClass!E && is(E:Entity)) {
			entity.remove;
			_entities = _entities.remove(_entities.countUntil(entity));
		}
		
		bool _removed = false;
	}
	protected {
		void update() {
			_addedEntities	= [];
		}
	}
	private {
		Entity[]	_entities	;
		Entity[]	_addedEntities	;
	}
}

abstract class Entity : EntityOwner {
	public {
		abstract @property bool flat();
		
		@property {
			float[2]	pos()	{ return virtualPos	; }
			void	pos(float[2] n)	{ virtualPos(n)	; }
			float	ori()	{ return virtualOri	; }
			void	ori(float n)	{ virtualOri(n)	; }
			float[2]	vel()	{ return virtualVel	; }
			void	vel(float[2] n)	{ virtualVel(n)	; }
			float	anv()	{ return virtualAnv	; }
			void	anv(float n)	{ virtualAnv(n)	; }
		}
	}
	package(galactic_.logic_world_) {
		this(float[2] pos=[0,0], float ori=0) {
			this.pos	= pos	;
			this.ori	= ori	;
			callSubInits;
		}
		void update() { // should only be called in `EntityOwner.removeEntity`
			callSubUpdates;
			foreach (entity; entities) 
				entity.update;
		}
		
		void _remove() {
			_removed = true;
		}
		
		protected {
			abstract void callSubInits();
			abstract void callSubUpdates();
		}
	}
	protected {
		abstract @property {
			float[2]	virtualPos();
			void	virtualPos(float[2]);
			float	virtualOri();
			void	virtualOri(float);
			float[2]	virtualVel();
			void	virtualVel(float[2]);
			float	virtualAnv();
			void	virtualAnv(float);
		}
	}
}

abstract class FlatEntity : Entity {
	public {
		final override @property bool flat() { return true; }
		NetEntity!true	netEntity;
	}
	package(galactic_.logic_world_) {
		this(float[2] pos=[0,0],float ori=0) {
			netEntity = new NetEntity!true;
			super(pos,ori);
		}
	}
	protected {
		override @property {
			float[2]	virtualPos()	{ return netEntity.pos	; }
			void	virtualPos(float[2] n)	{ netEntity.pos = n	; }
			float	virtualOri()	{ return netEntity.ori	; }
			void	virtualOri(float n)	{ netEntity.ori = n	; }
			float[2]	virtualVel()	{ return netEntity.vel	; }
			void	virtualVel(float[2] n)	{ netEntity.vel = n	; }
			float	virtualAnv()	{ return netEntity.anv	; }
			void	virtualAnv(float n)	{ netEntity.anv = n	; }
		}
	}
}


























