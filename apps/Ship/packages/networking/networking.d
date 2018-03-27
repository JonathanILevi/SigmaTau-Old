/**
This class is what handles this application specifice networking.

This class will connect clients and send messages from those clents to back.
*/
module networking;

import cst_;
import socket_msg_queue : SocketMsgQueue;

import std.stdio;
import std.socket;

import console_network.message	;

import console	;


private struct NetworkingConsole {
	Console	console	;
	SocketMsgQueue	msgQueue	;
}


class Networking {
	private {
		Socket	listener;

		ComponentType[]	componentTypes	;
		void delegate(Console console)	consoleConnectedCallback	;
		void delegate(Console console)	consoleDisconnectedCallback	;
		void delegate(Cts.Msg msg, Console sender)	msgCallback	;
		
		NetworkingConsole[]	consoles	;
	}

	this	(	string	ip	,
			ComponentType[]	componentTypes	,
			void delegate(Console console)	consoleConnectedCallback	,
			void delegate(Console console)	consoleDisconnectedCallback	,
			void delegate(Cts.Msg msg, Console sender)	msgCallback	,){
	
		this.componentTypes	= componentTypes	;
		this.consoleConnectedCallback	= consoleConnectedCallback	;
		this.consoleDisconnectedCallback	= consoleDisconnectedCallback	;
		this.msgCallback	= msgCallback	;
		
		//---listener
		{
			listener = new TcpSocket();
			listener.blocking = false;

			Address address;
			{
				string	justIp	;
				ushort	port	;
				{
					import std.algorithm : countUntil;
				
					size_t colonIndex = ip.countUntil(':');
				
					if (colonIndex == -1) {
						justIp	= ip	;
						port	= 128	;
					}
					else {
						import std.conv;
						justIp	= ip[0..colonIndex];
						auto portString	= ip[colonIndex+1..$];
						port	= portString.parse!ushort;
					}
				}
				address = parseAddress(justIp,port);
			}

			listener.bind(address);
			listener.listen(2);
		}
		//---
	}
	~this() {
		listener.shutdown(SocketShutdown.BOTH);
		listener.close();
	}
	
	void update() {
		{
			Socket cSoc;//consoleSocket
			cSoc = listener.accept();
			if (cSoc.isAlive) {
				cSoc.isAlive.writeln;
				writefln("Console connected: %s", cSoc.remoteAddress);
				NetworkingConsole console = NetworkingConsole(new Console(cSoc), new SocketMsgQueue(cSoc, (a=>a[0]+3)));
				
				consoles ~= console;
				consoleConnectedCallback(console.console);
			}
		}
		foreach_reverse(consoleIndex, console; consoles) {
			bool consoleClosed = console.msgQueue.closed;// Check if console got closed before we get any remaining msgs.
			foreach (msgData; console.msgQueue) {
				with (Cts) {
					/*cNum == msgData[1]*/pragma(inline, true)ubyte cNum() @property { return msgData[1]; }// componentNum
					/*msgType == msgData[2]*/pragma(inline, true) ubyte msgType() @property { return msgData[2]; }
					ComponentType cType; // componentType
					if (cNum == ubyte.max)	{ cType = ComponentType.other	;	}
					else	{ cType = componentTypes[cNum]	;	}
					
					if (cType==ComponentType.radar) {
						if (msgType == RadarMsg.Type.read)	{	msgCallback	( new RadarMsg.Read(msgData)	,console.console);	}
						if (msgType == RadarMsg.Type.stream)	{	msgCallback	( new RadarMsg.Stream(msgData)	,console.console);	}
					}
					else if (cType==ComponentType.thruster) {
						if (msgType == ThrusterMsg.Type.read)	{	msgCallback	( new ThrusterMsg.Read(msgData)	,console.console);	}
						if (msgType == ThrusterMsg.Type.stream)	{	msgCallback	( new ThrusterMsg.Stream(msgData)	,console.console);	}
						if (msgType == ThrusterMsg.Type.set)	{	msgCallback	( new ThrusterMsg.Set(msgData)	,console.console);	}
						if (msgType == ThrusterMsg.Type.adjust)	{	msgCallback	( new ThrusterMsg.Adjust(msgData)	,console.console);	}
					}
					else if (cType==ComponentType.other) {
						if (msgType == OtherMsg.Type.getComponents)	{	msgCallback	( new OtherMsg.GetComponents(msgData)	,console.console);	}
					}
					else {
						assert(false, "Bad component type for msg");
					}
				}
			}
			if (consoleClosed) {// Remove console if its socket was closed.
				import std.algorithm.mutation : remove;
				consoleDisconnectedCallback(console.console);
				consoles = consoles.remove(consoleIndex);
			}
		}
	}


}
