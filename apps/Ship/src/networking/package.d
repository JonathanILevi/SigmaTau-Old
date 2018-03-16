/**
This class is what handles this application specifice networking.

This class will connect clients and send messages from those clents the ship and ship components.
*/
module networking;

import networking.components	;
import networking.ship	;

class Networking {
	
	Ship	ship	;
	Component[]	components	;

	this(Ship ship, Component[] components) {
		this.ship	= ship	;
		this.components	= components	;
	}

	
	void update() {
		
	}


}


