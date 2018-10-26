module ship_.main_;
import commonImports;

import ship_.world_	.world_	;
import ship_.galactic_	.galactic_network_	;
import ship_.galactic_	.galactic_mgr_	;
import ship_.terminal_	.terminal_network_	;
import ship_.terminal_	.ship_	;

import loose_.sleep_ : sleep;
import core.time;

class Main {
	this() {
		auto galacticNetwork	= new GalacticNetwork	;
		auto terminalNetworkMaster	= new TerminalNetworkMaster	;
		auto world	= new World	;
		auto galacticMgr	= new GalacticMgr(world,galacticNetwork)	;
		auto ship	= new Ship(world)	;
		
		while (true) {
			sleep(200.msecs);
			galacticMgr	.update	( 	);
			ship	.update	( terminalNetworkMaster.getNewTerminals()	);
			galacticMgr	.send	( new ubyte[][0]	);
		}
	}
}

