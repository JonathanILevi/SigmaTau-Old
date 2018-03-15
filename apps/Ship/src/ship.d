/**
This file is for the `Ship` class.

The `Ship` class is mostly data references without much actual functionallity.

The `Ship` class also has the main event loop. (for now at least)
*/

import std.stdio;




class Ship {
	
	this () {
		mainLoop;
	}
	
	
	/**	This method runs the main event loop.
		Called in `this`
	*/
	private void mainLoop() {
		while (true) {
			import core.thread;
			import core.time;
			Thread.sleep(msecs(10));
				
			// call updates
		}
	}
	
	
	
}