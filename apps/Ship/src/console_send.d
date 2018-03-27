

module console_send;

import console;

void send(Msg)(Console console, Msg msg) if (__traits(compiles, "msg.byteData")) {
	console.socket.send(msg.byteData);
}