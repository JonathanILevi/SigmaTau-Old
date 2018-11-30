module terminal_msg_.down_ship_;
import commonImports;

import loose_	.serialize_	;

import terminal_msg_.msg_template_;

import terminal_msg_.component_type_;
public import terminal_msg_.up_;

enum MsgType {
	components	,
}
enum componentType = 255.cst!ComponentType;

mixin TypeTemplate;

class ComponentsMsg {
	@Exclude {
		enum type = MsgType.components;
		mixin MsgTemplate;
	}
	
	ComponentType[]	components;
}




