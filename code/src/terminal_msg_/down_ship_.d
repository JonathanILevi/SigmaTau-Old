module terminal_msg_.down_ship_;
import commonImports;

import xserial;

import terminal_msg_.msg_template_;

import terminal_msg_.component_type_;
public import terminal_msg_.up_;

enum MsgType {
	newComponent	,
}
enum msgComponentType = 255.cst!ComponentType;

mixin TypeTemplate;

class NewComponentMsg {
	@Exclude {
		enum type = MsgType.newComponent;
		mixin MsgTemplate;
	}
	
	ubyte	id	;
	ComponentType	componentType	;
}




