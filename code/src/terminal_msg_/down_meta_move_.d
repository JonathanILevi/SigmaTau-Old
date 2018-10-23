module terminal_msg_.down_meta_move_;

import std.experimental.logger;
import cst_;

import xserial;

import terminal_msg_.msg_template_;

import terminal_msg_.entity_;
import terminal_msg_.component_type_;
public import terminal_msg_.up_;
public import terminal_msg_.meta_move_;


enum MsgType {
	update	,
}
enum componentType = ComponentType.metaMove;

mixin TypeTemplate;

class UpdateMsg {
	@Exclude {
		enum type = MsgType.update;
		mixin MsgTemplate;
	}
	
	Axis	axis	;
	float	value	;
}






