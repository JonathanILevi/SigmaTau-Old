module terminal_msg_.down_meta_radar_;
import commonImports;

import loose_	.serialize_	;

import terminal_msg_.msg_template_;

import terminal_msg_.component_type_;
public import terminal_msg_.up_;

enum MsgType : ubyte {
	add	,
	update	,
	remove	,
	moveAll	,
}
enum componentType = ComponentType.metaRadar;

mixin TypeTemplate;

class AddMsg {
	@Exclude {
		enum type = MsgType.add;
		mixin MsgTemplate;
	}
	
	ushort	id	;
	float[2]	pos	;
	float	ori	;
}
class RemoveMsg {
	@Exclude {
		enum type = MsgType.remove;
		mixin MsgTemplate;
	}
	
	ushort	id	;
}
class UpdateMsg {
	@Exclude {
		enum type = MsgType.update;
		mixin MsgTemplate;
	}
	
	ushort	id	;
	float[2]	pos	;
	float	ori	;
}
class MoveAllMsg {
	@Exclude {
		enum type = MsgType.moveAll;
		mixin MsgTemplate;
	}
	
	float[2]	pos	;
	float	ori	;
}





