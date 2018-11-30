module terminal_msg_.msg_template_;
import commonImports;


mixin template  MsgTemplate(){
	alias Msg = typeof(this);
	this(ubyte component=255) {
		this.component = component;
	}
	static Msg opCall(ubyte component=255) {
		return new Msg(component);
	}
	static Msg opCall(UnknownMsg msg) {
		return Msg(msg.msgData);
	}
	static Msg opCall(const(ubyte)[] msgData) {
		assert(msgData[0] == msgData.length);
		assert(type==msgData[2]);
		return msgData[3..$].deserialize!Msg;
	}
	
	@property
	const(ubyte)[] msgData() {
		static if (componentType!=255) {
			assert(component!=255);
		}
		auto data = this.serialize;
		data = [(data.length+3).cst!ubyte, component.cst!ubyte, type.cst!ubyte]~data;
		assert(data.length == data[0]);
		return data;
	}
	alias msgData this;
	
	private ubyte component;
}


mixin template UnknownMsgTemplate() {
	const(ubyte)[] msgData;
	
	@property
	ubyte component() {
		assert(msgData.ptr && msgData.length>=3);
		return msgData[1];
	}
	// type is gotten using ufcs function in component specific module.
}

mixin template TypeTemplate() {
	@property
	MsgType type(UnknownMsg msg) {
		assert(msg.msgData.ptr && msg.msgData.length>=3);
		return msg.msgData[2].cst!MsgType;
	}
}


