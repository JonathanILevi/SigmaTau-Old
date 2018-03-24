/**
MsgQueue takes a socket and recieves and converts the buffer to mesages to individual mesages.
MsgQueue assumes that the first byte of a msg is the mesages length + 3(for msg header).
*/


module msg_queue	;

import cst_;

import queue	;
import core.thread	;
import std.socket	;



class MsgQueue {
	private {
		Socket socket	;
		Queue!(ubyte[]) queue	;
		
		MsgThread msgThread;
	}
	
	this(Socket socket) {
		this.socket	= socket	;
		this.queue	= new Queue!(ubyte[])	;
				
		this.msgThread	= new MsgThread(socket, queue)	;

		socket.blocking = true;
		
		msgThread.start();
	}
	
	auto empty()	{ return queue.empty	;	}
	auto popFront()	{ return queue.popFront	;	}
	auto front()	{ return queue.front	;	}	
}


// If msg length is less than three the msg is from the msgThread to the network handler
private enum MsgThreadMsgType : ubyte {
	closed	,
}



private class MsgThread : Thread {
	private:

	public this(Socket socket, Queue!(ubyte[]) queue) {
		this.socket	= socket	;
		this.queue	= queue	;

		super(&run);
	}
	
	Socket	socket	;
	Queue!(ubyte[])	queue	;
			
	ubyte[258]	buffer	;// 258 = 255+3  (max msg size (ubyte) plus header)
	ubyte[]	partialMsg	;
	uint	readLength	;// The current length of the read data.
	
	private void run() {
		while (true) {
			import core.time : msecs;
			Thread.sleep(msecs(60));

			ptrdiff_t length = socket.receive(buffer[readLength..$]);
			if (length==0 || length==Socket.ERROR) {
				queue.put([MsgThreadMsgType.closed.cst!ubyte]);
				continue;
			}
			////readLength += length;
			////import std.math : min;
			partialMsg ~= buffer[0..length];
			
			if (partialMsg.length >= partialMsg[0]+3) {//+3 for header
				queue.put(partialMsg[0..partialMsg[0]+3]);
				partialMsg = partialMsg[partialMsg[0]+3..$];
			}
		}
	}
	
}










