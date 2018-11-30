module terminal_msg_.up_meta_move_;
import commonImports;

import loose_	.serialize_	;

import terminal_msg_.msg_template_;

import terminal_msg_.component_type_;
public import terminal_msg_.up_;
public import terminal_msg_.meta_move_;

enum MsgType {
	read	,
	stream	,
	set	,
}
enum componentType = ComponentType.metaMove;

mixin TypeTemplate;

class ReadMsg {
	@Exclude {
		enum type = MsgType.read;
		mixin MsgTemplate;
	}
	
	Axis axis;
}

class StreamMsg {
	@Exclude {
		enum type = MsgType.stream;
		mixin MsgTemplate;
	}
	
	Axis axis;
}

class SetMsg {
	@Exclude {
		enum type = MsgType.set;
		mixin MsgTemplate;
	}
	
	Axis	axis	;
	float	value	;
}



