/**
The base class for all the components.
*/
module components.component;


import std.stdio;

import cst_;

import console_network.message;

import console;

import	networking	;
static import	networking.components	;
alias ConponentNetworkCallbackInterface = networking.Component;



abstract class Component : ConponentNetworkCallbackInterface {
	this () {
		
	}
	abstract ComponentType type() @property;
	ComponentType opCast(T:ComponentType)() {
		return this.type;
	}
}














