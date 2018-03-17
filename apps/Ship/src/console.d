/**
A class for a console.

Consoles are identified by the the class pointer itself so it has no special id. 
*/
import msg_queue;
import std.socket;

class Console {
	this(Socket socket) {
		this.socket	= socket	;
		this.msgQueue	= new MsgQueue(socket)	;
	}
	~this() {
		socket.shutdown(SocketShutdown.BOTH);
		socket.close();
	}
	
	Socket	socket	;
	MsgQueue	msgQueue	;// for `networking`
}