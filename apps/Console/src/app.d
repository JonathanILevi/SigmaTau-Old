

import cst_;

import std.stdio;

import std.socket;

import msg_queue	;
import console_network.message	;




void main() {
	Console console = new Console();
}



class Console {
	Socket socket;
	MsgQueue msgQueue;
	ComponentType[] shipComponents;


	this() {
		socket = new TcpSocket();
		socket.connect(parseAddress("127.0.0.1",128));
		
		msgQueue = new MsgQueue(socket);
		
		Cts.OtherMsg.GetComponents msg;

		socket.send(msg.byteData);
		

		mainLoop;
	}
	~this() {
		socket.shutdown(SocketShutdown.BOTH);
		socket.close();
	}


	void mainLoop() {
		while (true) {
			import core.thread;
			import core.time;
			Thread.sleep(msecs(10));
			
			foreach (msg; msgQueue) {
				msg.writeln;
				if (msg[1]==ComponentType.other) {
					if (msg[2] == Stc.OtherMsg.Type.components) {
						shipComponents = msg[3..$].cst!(ComponentType[]);
						shipComponents.writeln;
					}
				}
			}
		}
	}
}








