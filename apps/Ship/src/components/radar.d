/*
The `radar` component.
*/
module components.radar;


import std.stdio;

import cst_;

import console_network.message;

import console;

import components.component;

import	networking	;
static import	networking.components	;
alias RadarNetworkCallbackInterface = networking.Radar;



class Radar : Component, RadarNetworkCallbackInterface {
	override ComponentType type() @property { return ComponentType.radar; }

	this () {

	}

	//---msg callbacks
	public {
		private alias Msg = Cts.ComponentMsg!(ComponentType.radar);

		void on_read(Msg.Msg!(Msg.Type.read) msg, Console sender) {
			"Got read msg to radar.".writeln;
		}
		void on_stream(Msg.Msg!(Msg.Type.stream) msg, Console sender) {
			"Got stream msg to radar.".writeln;
		}
	}
}








