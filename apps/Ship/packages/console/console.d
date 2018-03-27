/**
A class for a console.

Consoles are identified by the the class pointer itself so it has no special id. 
*/

module console;

import std.socket;

class Console {
	this(Socket socket) {
		this.socket	= socket	;
	}
	~this() {
		socket.shutdown(SocketShutdown.BOTH);
		socket.close();
	}

	Socket	socket	;
}

