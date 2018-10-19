module galactic_msg_.down_;

import std.experimental.logger;
import cst_;

import loose_.net_msg_;

enum MsgType {
	add	,
	remove	,
	update	,
	moveAll	,
}

struct UnknownMsg {
	const(ubyte)[] msgData;
	
	@property
	MsgType type() {
		assert(msgData.ptr && msgData.length>=2);
		return msgData[1].cst!MsgType;
	}
}


class AddMsg {
	import galactic_msg_.entity_;
	static AddMsg opCall() {
		return new AddMsg;
	}
	static AddMsg opCall(UnknownMsg msg) {
		return AddMsg(msg.msgData);
	}
	static AddMsg opCall(const(ubyte)[] msgData) {
		return msgData.decodeNetMsg!AddMsg(MsgType.add);
	}
	
	@Net ushort	id	;
	@Net float[2]	pos	;
	@Net float	ori	;
	
	@property
	const(ubyte)[] msgData() {
		return this.encodeNetMsg(MsgType.add);
	}
	alias msgData this;
}
class RemoveMsg {
	import galactic_msg_.entity_;
	static RemoveMsg opCall() {
		return new RemoveMsg;
	}
	static RemoveMsg opCall(UnknownMsg msg) {
		return RemoveMsg(msg.msgData);
	}
	static RemoveMsg opCall(const(ubyte)[] msgData) {
		return msgData.decodeNetMsg!RemoveMsg(MsgType.remove);
	}
	
	@Net ushort	id	;
	
	@property
	const(ubyte)[] msgData() {
		return this.encodeNetMsg(MsgType.remove);
	}
	alias msgData this;
}
class UpdateMsg {
	import galactic_msg_.entity_;
	static UpdateMsg opCall() {
		return new UpdateMsg;
	}
	static UpdateMsg opCall(UnknownMsg msg) {
		return UpdateMsg(msg.msgData);
	}
	static UpdateMsg opCall(const(ubyte)[] msgData) {
		return msgData.decodeNetMsg!UpdateMsg(MsgType.update);
	}
	
	@Net ushort	id	;
	@Net float[2]	pos	;
	@Net float	ori	;
	
	@property
	const(ubyte)[] msgData() {
		return this.encodeNetMsg(MsgType.update);
	}
	alias msgData this;
}
class MoveAllMsg {
	import galactic_msg_.entity_;
	static MoveAllMsg opCall() {
		return new UpdateMsg;
	}
	static MoveAllMsg opCall(UnknownMsg msg) {
		return MoveAllMsg(msg.msgData);
	}
	static MoveAllMsg opCall(const(ubyte)[] msgData) {
		return msgData.decodeNetMsg!MoveAllMsg(MsgType.moveAll);
	}
	
	@Net float[2]	pos	;
	@Net float	ori	;
	
	@property
	const(ubyte)[] msgData() {
		return this.encodeNetMsg(MsgType.moveAll);
	}
	alias msgData this;
}





