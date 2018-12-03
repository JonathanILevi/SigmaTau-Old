module galactic_.logic_world_.world_;
import commonImports;

import std.traits;

import galactic_.logic_world_.entities_	.entity_	;
import galactic_.logic_world_.entities_	.ship_	;
import galactic_.logic_world_.entities_	.entities_	;

class World : EntityOwner {
	public {
		this() {
			import std.random;
			////addEntity(new Asteroid([uniform(-100,100)*0.1,uniform(-100,100)*0.1],uniform(-100,100)*0.01,[uniform(-100,100)*0.01,uniform(-100,100)*0.01],0));
			addEntity(new Asteroid());
			foreach (_; 0..1) {
				import std.random;
				addEntity(new Asteroid([uniform(-100,100)*0.1,uniform(-100,100)*0.1],uniform(-100,100)*0.01,[0,0],0));
			}
		}
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
					}	
				}
				counter = 0;
			}
			foreach (entity; entities) {
				entity.update;
			}
			
			return newPlayerShips;
		}
	}
	private {
		uint counter = 0;
	}
}


