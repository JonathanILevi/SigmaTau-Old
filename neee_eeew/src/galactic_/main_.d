module galactic_.main_;

import std.experimental.logger;

import galactic_.network_;
import galactic_.ship_mgr_;
import galactic_.world_;
import galactic_.game_logic_;

import loose_.sleep_ : sleep;
import core.time;

class Main {
	this(int gameTick) {
		auto network	= new NetworkMaster	;
		auto world	= new World	;
		auto gameLogic	= new GameLogic(world)	;
		auto shipMgr	= new ShipMgr(world, gameTick)	;
		
		while (true) {
			sleep(gameTick.msecs);
			/*null*/	gameLogic	.update()	;
			/*null*/	shipMgr	.update(newNetworks)	;
		}
	}
}

