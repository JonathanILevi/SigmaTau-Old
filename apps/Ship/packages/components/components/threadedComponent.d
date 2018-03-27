/**
The base class for threaded components. (Components that run a separate thread.)
*/
module components.threadedComponent;


import std.stdio;

import cst_;

import queue;

import components.component;

import console_network.message;

import console;



struct QueueMsg {
	Cts.Msg	msg	;
	Console	console	;
}

abstract class ThreadedComponent : Component {
	abstract override ComponentType type() @property;

	override void onMsg(Cts.Msg msg, Console console) {
		msgQueue.put(QueueMsg(msg,console));
	}
	protected Queue!(QueueMsg) msgQueue = new Queue!(QueueMsg);

	override void update() {};
}














