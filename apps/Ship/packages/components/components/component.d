/**
The base class for all the components.
*/
module components.component;


import std.stdio;

import cst_;

import console_network.message;

import console;


abstract class Component {
	abstract ComponentType type() @property;
	abstract void onMsg(Cts.Msg msg, Console console);
	ComponentType opCast(T:ComponentType)() {
		return this.type;
	}
	
	void update() {};
}














