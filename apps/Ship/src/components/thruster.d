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
static import	networking.components	;
alias ThrusterNetworkCallbackInterface = networking.Thruster;



class Thruster : Component, ThrusterNetworkCallbackInterface {
	override ComponentType type() @property { return ComponentType.thruster; }

	this () {

	}
	
	//---msg callbacks
	public {
		private alias Msg = Cts.ComponentMsg!(ComponentType.thruster);
		
		void on_read(Msg.Msg!(Msg.Type.read) msg, Console sender) {
			"Got read msg to thruster.".writeln;
		}
		void on_stream(Msg.Msg!(Msg.Type.stream) msg, Console sender) {
			"Got stream msg to thruster.".writeln;
		}
		void on_set(Msg.Msg!(Msg.Type.set) msg, Console sender) {
			"Got set msg to thruster.".writeln;
		}
		void on_adjust(Msg.Msg!(Msg.Type.adjust) msg, Console sender) {
			"Got adjust msg to thruster.".writeln;
		}
	}
}














