module galactic_.game_logic_.game_logic_;

import std.experimental.logger;
import cst_;

import galactic_.game_logic_	.entity_;
import galactic_.game_logic_	.world_;

class GameLogic {
	this() {
		this.world	= new World	;
	}
	void update() {
		world.entities.length.log;
		if (++counter == 5) {
			import std.random;
			world.entities ~= new Entity([0,0],0,[uniform(-100,100)*0.01,uniform(-100,100)*0.01],uniform(-100,100)*0.01);
			if (world.entities.length>10) {
				world.entities = world.entities[1..$];
			}
			counter = 0;
		}
		foreach (entity; world.entities) {
			entity.pos[]	+= entity.vel[]	;
			entity.ori	+= entity.anv	;
		}
	}
	World getWorld() {return world;}
	private {
		World world;
		
		uint counter = 0;
	}
}

