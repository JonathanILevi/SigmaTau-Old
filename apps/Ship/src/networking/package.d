/**
This class is what handles this application specifice networking.

This class will connect clients and send messages from those clents the ship and ship components.
*/
module networking;

import cst_;

import std.stdio;
import std.socket;

import networking.components	;
import networking.ship	;

import console_network.message	;

import console	;



class Networking {
	
	Ship	ship	;
	Component[]	components	;

	Socket	listener;
	Console[] consoles;

	this(Ship ship, Component[] components, string ip) {
		this.ship	= ship	;
		this.components	= components	;
		
		//---socket
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
				consoles ~= new Console(cSoc);
				ship.on_consoleConnected(consoles[$-1]);
			}
		}
		foreach_reverse(consoleIndex, console; consoles) {

			foreach (msgData; console.msgQueue) {
				// Msg from msgThread
				if (msgData.length < 3) {
					if (msgData[0] == MsgThreadMsgType.closed) {
						import std.algorithm.mutation : remove;
						ship.on_consoleDisconnected(console);
						consoles = consoles.remove(consoleIndex);
						continue;
					}
					else {
						assert(0, "Unknown msgThreadMsg.");
					}
				}
				// Normal msg
				with (Cts) {
					/*cNum == msgData[1]*/pragma(inline, true)ubyte cNum() @property { return msgData[1]; }// componentNum
					/*msgType == msgData[2]*/pragma(inline, true) ubyte msgType() @property { return msgData[2]; }
					ComponentType cType; // componentType
					if (cNum == ubyte.max)	{ cType = ComponentType.other	;	}
					else	{ cType = components[cNum].type	;	}
								
					if (cType==ComponentType.radar) {
						if (msgType == RadarMsg.Type.read)	{	components[cNum].newMsg	( new RadarMsg.Read(msgData)	,console);	}
						if (msgType == RadarMsg.Type.stream)	{	components[cNum].newMsg	( new RadarMsg.Stream(msgData)	,console);	}
					}
					else if (cType==ComponentType.thruster) {
						if (msgType == ThrusterMsg.Type.read)	{	components[cNum].newMsg	( new ThrusterMsg.Read(msgData)	,console);	}
						if (msgType == ThrusterMsg.Type.stream)	{	components[cNum].newMsg	( new ThrusterMsg.Stream(msgData)	,console);	}
						if (msgType == ThrusterMsg.Type.set)	{	components[cNum].newMsg	( new ThrusterMsg.Set(msgData)	,console);	}
						if (msgType == ThrusterMsg.Type.adjust)	{	components[cNum].newMsg	( new ThrusterMsg.Adjust(msgData)	,console);	}
					}
					else if (cType==ComponentType.other) {
						if (msgType == OtherMsg.Type.getComponents)	{	ship.on_getComponents	( new OtherMsg.GetComponents(msgData)	,console);	}
					}
					else {
						assert(false, "Bad component type for msg");
					}
				}
			}
		}
	}


}