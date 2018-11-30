module terminal_msg_.up_meta_radar_;
import commonImports;

import loose_	.serialize_	;

import terminal_msg_.msg_template_;

import terminal_msg_.component_type_;
public import terminal_msg_.up_;

enum MsgType {
	read	,
	stream	,
}
enum componentType = ComponentType.metaRadar;

mixin TypeTemplate;

class ReadMsg {
	@Exclude {
		enum type = MsgType.read;
		mixin MsgTemplate;
	}
}

class StreamMsg {
	@Exclude {
		enum type = MsgType.stream;
		mixin MsgTemplate;
	}
}




