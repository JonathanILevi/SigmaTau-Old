/**
This file is for the `Ship` class.

The `Ship` class is mostly data references without much actual functionallity.

The `Ship` class also has the main event loop. (for now at least)
*/

import std.stdio;

import cst_;

import console_network.message;

import console;

import components.component;

import	networking	;
static import	networking.ship	;
alias ShipNetworkCallbackInterface = networking.Ship;




class Ship : ShipNetworkCallbackInterface {
	
	this (string ip) {
		addComponent!(ComponentType.radar)();
		addComponent!(ComponentType.thruster)();
		addComponent!(ComponentType.thruster)();
		mainLoop;
	}
	
	//---components
	public {
		Component[] components;
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
	
	
	/**	Used internally to add a component.
		Currently the components cannot change while a console is connented.
	*/
	private void addComponent(ComponentType componentType)() {
		with (ComponentType) {
			import components;
			static if	(componentType == radar	) {	this.components ~= new Radar	()	;}
			else if	(componentType == thruster	) {	this.components ~= new Thruster	()	;}
		}
		writeln(components);
	}
	
	
	//---ShipNetworkCallbackInterface callbacks
	public {
		void on_consoleConnected(Console console) {
			"console connected".writeln;
		}
		void on_consoleDisconnected(Console console) {
			"console disconnenctid".writeln;
		}
		
		void on_getComponents(Cts.OtherMsg.GetComponents msg, Console sender) {
			"getComponents".writeln;
		}
	}
	
	
	
}


