module ship_.galactic_network_;

import std.experimental.logger;

import vibe.core.net;
import eventcore.driver	: IOMode;

import loose_.to_msg_;

class GalacticNetwork {
	this() {
		void createSocket() {
			auto s = connectTCP("127.0.0.1", 1234);
			socket = &s;
			_vibeSocketHandlerStillExists = true;
			"Connected to server".log;
			this.toMsg = new ToMsg(
				(){
					if (socket.dataAvailableForRead) {
						enum bufferSize = 64;
						ubyte[] buffer = new ubyte[bufferSize];
						auto length = socket.read(buffer, IOMode.once);
						while (length==buffer.length) {
							buffer.length += bufferSize;
							length += socket.read(buffer[$-bufferSize..$], IOMode.once);
						}
						return buffer[0..length];
					}
					return new ubyte[0];
				},
				(buffer=>buffer.length>0?buffer[0]:0)
			);
			while (s.connected){
				import vibe.core.core : sleep;
				import core.time;
				sleep(1.seconds);
			}
			_vibeSocketHandlerStillExists = false;
			"Disconnected from server".log;
		}
		import vibe.core.core : runTask;
		runTask(&createSocket);
	}
	
	private {
		TCPConnection*	socket;
		ToMsg	toMsg;
	}
	
	@property bool connected() {
		return _vibeSocketHandlerStillExists && socket.connected;
	}
	private bool _vibeSocketHandlerStillExists = false; // should only be changed by the vibe tcp connected handler function (`this.this.createSocket`)
	//---Send
	public {
		void send(const(ubyte[]) msg) {
			if (connected) {
				socket.write(msg);
			}
		}
		alias put = send;
	}
	
	//---Receive
	public {
		@property bool empty() {
			if (connected) {
				return toMsg.empty;
			}
			return true;
		}
		@property const(const(ubyte)[]) front() {
			return toMsg.front;
		}
		void popFront() {
			return toMsg.popFront;
		}
	}
}


