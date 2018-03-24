/*
The `radar` component.
*/
module components.thruster;


import std.stdio;

import cst_;

import console_network.message;

import console;

import components.component;

import	networking	;



class Thruster : Component {
	override ComponentType type() @property { return ComponentType.thruster; }

	this () {

	}
	
	override void newMsg(Cts.Msg msg, Console console) {
		msg.writeln;
	}
}














