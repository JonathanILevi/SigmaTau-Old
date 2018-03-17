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
	
	Socket	socket	;
	MsgQueue	msgQueue	;// for `networking`
}