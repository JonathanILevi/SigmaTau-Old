/*
The `radar` component.
*/
module components.components.thruster;


import std.stdio;

import cst_;

import console_network.message;

import console;

import components.component;



class Thruster : Component {
	override ComponentType type() @property { return ComponentType.thruster; }

	this () {

	}
	
	override void onMsg(Cts.Msg msg, Console console) {
		msg.writeln;
	}
}














