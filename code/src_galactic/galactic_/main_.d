module galactic_.main_;
import commonImports;

import galactic_.network_	.network_	;
import galactic_.logic_world_	.world_	;
import galactic_	.debug_	;

import loose_.sleep_ : sleep;
import core.time;

class Main {
	this(int gameTick) {
		gameTick = 1000;
		auto network	= new NetworkMaster	;
		auto world	= new World	;
		auto cli	= new CLI(world)	;
		
		while (true) {
			sleep(gameTick.msecs);
			auto newNetworks	= network	.getNewNetworks()	;
			auto newPlayerShips	= world	.update(newNetworks.length)	;
			
			cli.update();
		}
	}
}


