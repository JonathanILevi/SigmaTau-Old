module galactic_.ship_.ship_mgr_;
import commonImports;

import loose_.sleep_;
import core.time;

import galactic_.ship_	.ship_	:	Ship	;
import galactic_.flat_world_	.world_	:	World	;
import galactic_.network_	.network_	:	Network	;
import galactic_.logic_world_	.ship_	:	ShipEntity = Ship	;

import std.algorithm.iteration	;
import std.range	:	array	;

class ShipMgr {
	this(World world, int gameTick) {
		this.world	= world	;
		this.gameTick	= gameTick	;
	}
	void update(Network[] newNetworks, ShipEntity[] newShipEntities) {
		looseNetworks	~= newNetworks	;
		looseShipEntities	~= newShipEntities	;
		////this.ships ~= newNetworks.map!(n=>new Ship(world, n)).array;
		while (looseNetworks.length>0 && looseShipEntities.length>0) {
			ships ~= new Ship(world, looseShipEntities[0], looseNetworks[0]);
			looseNetworks	= looseNetworks[1..$]	;
			newShipEntities	= newShipEntities[1..$]	;
		}
		foreach (ship; ships) {
			ship.update();
		}
	}
	
	private {
		World	world	;
		int	gameTick	;
		Network[]	looseNetworks	; // Networks not attached to a ship
		ShipEntity[]	looseShipEntities	; // Unattached ship entities
		Ship[]	ships	;
	}
}

