module terminal_msg_.up_ship_;
import commonImports;

import xserial;

import terminal_msg_.msg_template_;

import terminal_msg_.component_type_;
public import terminal_msg_.up_;

enum MsgType {
	test	,
}
enum msgComponentType = 255.cst!ComponentType;

mixin TypeTemplate;

class TestMsg {
	@Exclude {
		enum type = MsgType.test;
		mixin MsgTemplate;
	}
	
	ubyte	testByte	;
	ubyte[]	testArray	;
}




