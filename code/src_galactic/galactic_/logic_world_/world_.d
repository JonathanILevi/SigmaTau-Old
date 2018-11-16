module galactic_.logic_world_.world_;
import commonImports;

import std.traits;

import galactic_msg_	.galactic_msg_	: NetWorld = World;
import galactic_.logic_world_.entities_	.entity_	;
import galactic_.logic_world_.entities_	.ship_	;
import galactic_.logic_world_.entities_	.entities_	;

class World : EntityMaster {
	this() {
		import std.random;
		////addEntity(new Asteroid([uniform(-100,100)*0.1,uniform(-100,100)*0.1],uniform(-100,100)*0.01,[uniform(-100,100)*0.01,uniform(-100,100)*0.01],0));
		addEntity(new Asteroid());
		foreach (_; 0..1) {
			import std.random;
			addEntity(new Asteroid([uniform(-100,100)*0.1,uniform(-100,100)*0.1],uniform(-100,100)*0.01,[0,0],0));
		}
	}
	
	private Entity[]	_entities	;
	@property Entity[] entities() {
		return _entities~[];	// Shallow copy the array, so that only the data in the `Entity` will be affected.
			// It would be far better to just pass an const(headconst(Entity)[]) but D does not support this.
	}
	
	NetWorld!true	netWorld	= new NetWorld!true;
	
	Ship[] update(size_t numNewPlayers) {
		Ship[] newPlayerShips = [];
		foreach (_; 0..numNewPlayers) {
			newPlayerShips ~= new Ship([0,0],0,[0,0],0);
		}
		foreach (ship; newPlayerShips) {
			addEntity(ship);
		}
		if (++counter == 2) {
			import std.random;
			addEntity(new Asteroid([-1,0],1,[uniform(-100,100)*0.01,uniform(-100,100)*0.01],uniform(-100,100)*0.01));
			if (entities.length>4) {
				foreach (i; 5..entities.length) {
					if (entities[i].type==EntityType.asteroid) {
						removeEntity(entities[i].cst!Asteroid);
						break;
					}
				}	
			}
			counter = 0;
		}
		foreach (entity; entities) {
			entity.update;
		}
		netWorld.networkVar_update((msg){msg.log;}, []);
		
		return newPlayerShips;
	}
	uint counter = 0;
	
	void addEntity(E)(E entity) if(!isAbstractClass!E) {
		entity.master = this;
		this._entities~=entity;
		entity.addedToWorld();
		static if (is(E:FlatEntity)) {
			onAddedFlatEntity(entity);
		}
	}
	void removeEntity(E)(E entity) if(!isAbstractClass!E) {
		entity.removedFromWorld();
		_entities = _entities.remove(_entities.countUntil(entity));
		static if (is(E:FlatEntity)) {
			onRemovedFlatEntity(entity);
		}
		entity.master = null;
	}
	
	
	void onAddedFlatEntity(FlatEntity entity) {
		netWorld.entities_add(entity.netEntity);
	}
	void onRemovedFlatEntity(FlatEntity entity) {
		netWorld.entities_remove(entity.netEntity);
	}
}


