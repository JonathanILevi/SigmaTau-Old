/**
This file is for the `Ship` class.

The `Ship` class is mostly data references without much actual functionallity.

The `Ship` class also has the main event loop. (for now at least)
*/

module ship;

import std.stdio;

import cst_;

import console_network.message;

import console;
import console_send;
////import entity.entities;

import components.component;

import networking;



class Ship {
	
	this (string ip) {
		addComponent!(ComponentType.radar)();
		addComponent!(ComponentType.thruster)();
		addComponent!(ComponentType.thruster)();
		
		import std.conv : to;
		this.networking = new Networking	(	ip	,
				this.components.to!(ComponentType[])	,
				&onConsoleConnected	,
				&onConsoleDisconnected	,
				&onMsg	,);
		mainLoop;
	}
	

	Networking	networking;
	
	//---components
	public {
		Component[] components;
		
		////Entities entities;
	}
	
	
	/**	This method runs the main event loop.
		Called in `this`
	*/
	private void mainLoop() {
		while (true) {
			import core.thread;
			import core.time;
			Thread.sleep(msecs(10));
			
			networking.update;
		}
	}
	
	
	/**	Used internally to add a component.
		Currently the components cannot change while a console is connented.
	*/
	private void addComponent(ComponentType componentType)() {
		with (ComponentType) {
			import components.components;
			static if	(componentType == radar	) {	this.components ~= new Radar	()	;}
			else if	(componentType == thruster	) {	this.components ~= new Thruster	()	;}
		}
		writeln(components);
	}
	
	
	//---Networking callbacks
	public {
		void onConsoleConnected(Console console) {
			"console connected".writeln;
		}
		void onConsoleDisconnected(Console console) {
			"console disconnencted".writeln;
		}
		void onMsg(Cts.Msg msg, Console sender) {
			msg.writeln;
			if (msg.component == ubyte.max) {
				if (msg.type == Cts.OtherMsg.Type.getComponents) {
					onGetComponents(msg.cst!(Cts.OtherMsg.GetComponents), sender);
				}
				else {
					assert(false, "Unknown msg type for \"other\" component." );
				}
			}
			else {
				components[msg.component].onMsg(msg, sender);
			}
		}
	}
	
	//---Msgs for "other" component
	public {
		void onGetComponents(Cts.OtherMsg.GetComponents msg, Console sender) {
			Stc.OtherMsg.Components res = new Stc.OtherMsg.Components;//response
			this.components.writeln;

			import std.conv : to;
			this.components.to!(ComponentType[]).writeln;
			res.components = this.components.to!(ComponentType[]);
			res.byteData.writeln;
			sender.send(res);
			"getComponents".writeln;
		}
	}
	
	
	
}


