/*
The `radar` component.
*/
module components.components.radar;


import std.stdio;

import core.thread;

import cst_;

import queue;

import console_network.message;

import console;

import components.threadedComponent;



class Radar : ThreadedComponent {
	override ComponentType type() @property { return ComponentType.radar; }
	
	RadarThread thread;

	this () {
		thread = new RadarThread(msgQueue);
	}
	
}


private class RadarThread : Thread {
	Queue!QueueMsg msgQueue;
	
	this(Queue!QueueMsg msgQueue) {
		super(&thread);
		this.msgQueue = msgQueue;
		start;
	}
	
	private void thread() {
		while (true) {
			import core.time;
			Thread.sleep(msecs(10));
			
			foreach (msg; msgQueue) {
				msg.writeln;
			}
		}
	}
}








