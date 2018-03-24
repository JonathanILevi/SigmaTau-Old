/**
This is the msg classes and such to make dealing with network msgs for natural.
*/

module console_network.message;

import cst_;

import std.stdio;

public import	console_network.enums	;
private import	console_network.msg_structure_spec	;


/**	This is an enum to mark the direction the msg is designed to go.
	This is use for template namespaces for msg types.
	This enum does not need to be used outside of this file, the `Cts`&`Stc` namespace template mixins are normally easier.
*/
enum MsgDirection : bool {
	consoleToShip	= false	,
	shipToConsole	= true	,
	cts	= false	,
	stc	= true	,
}
alias MsgDir = MsgDirection;



/**	The namespace with all the "Console to Ship" specifice types, data, and code.
*/
template Messages(MsgDirection msgDirection) {
	private enum cts = msgDirection == MsgDirection.cts;
	private enum stc = msgDirection == MsgDirection.stc;





	/**	Msg code specific to a type of componet.
	*/
	template ComponentMsg(ComponentType componentType) {
		// Adds an alias for the msg type for this component.
		import std.string	: capitalize	;
		import std.conv	: to	;
		mixin("alias Type = "~(cts?"Cts":"Stc")~componentType.to!string.toUpperFirst~"MsgType"~";");



		/**	A class to deal with msg data.
			This class is not required for a console to work, but is convenient to deal with the network messages.
		*/
		class Msg(Type msgType) : Messages!msgDirection.Msg {
			mixin("private alias ValueBodyData = "~(cts?"Cts":"Stc")~componentType.to!string.toUpperFirst~"MsgBody"~msgType.to!string.toUpperFirst~";");

			ubyte[calcBodyLength!ValueBodyData()] byteBody;


			Type type	() {	assert(msgType==byteHeadPartial[1], "class msg type and `byteData` msg type do not match")	;
					return byteHeadPartial[1].cst!(Type)	;}

			static foreach(Value; ValueBodyData.Values) {
				@property {
					mixin("Value.Type "~Value.name~"(){ return *((&byteBody[offset!ValueBodyData(Value.name)]).cst!(void*).cst!(Value.Type*));}");
					mixin("void "~Value.name~"(Value.Type value){ *((&byteBody[offset!ValueBodyData(Value.name)]).cst!(void*).cst!(Value.Type*)) = value;}");
				}
			}

			this() {
				byteHeadPartial[1] = msgType;
			}
			this(ubyte[] data) {
				byteHeadPartial = data[1..3];
				byteBody = data[3..3+bodyLength];
				assert(msgType==byteHeadPartial[1], "class msg type and `byteData` msg type do not match")	;
			}


			@property static ubyte bodyLength() {
				return calcBodyLength!ValueBodyData;
			}
			override @property {
				ubyte length(){
					return 3+bodyLength & 0xFF;
				}
				ubyte[] byteData() {
					return bodyLength~byteHeadPartial~byteBody;
				}
			}
		}






		//---Aliases for easier use of template.
		static if (cts) {
			static if (componentType == ComponentType.radar) {
				alias Read	= Msg!(Type.read)	;
				alias Stream	= Msg!(Type.stream)	;
			}
			static if (componentType == ComponentType.thruster) {
				alias Read	= Msg!(Type.read)	;
				alias Stream	= Msg!(Type.stream)	;
				alias Set	= Msg!(Type.set)	;
				alias Adjust	= Msg!(Type.adjust)	;
			}
			static if (componentType == ComponentType.other) {
				alias GetComponents	= Msg!(Type.getComponents)	;
			}
		}
		static if (stc) {
			static if (componentType == ComponentType.radar) {
				alias Pip	= Msg!(Type.pip)	;
			}
			static if (componentType == ComponentType.thruster) {
				alias Power	= Msg!(Type.power)	;
			}
			static if (componentType == ComponentType.other) {
				alias Components	= Msg!(Type.components)	;
			}
		}
		//---

	}






	/**	Base msg class
	*/
	abstract class Msg {
		ubyte[2]	byteHeadPartial;
		
		//---Always values
		@property {
			ubyte component	() {	return byteHeadPartial[0]	;}
			abstract {
				ubyte	length();
				ubyte[]	byteData();
			}
		}
	}





	//---Aliases for easier use of template.
	alias RadarMsg	= ComponentMsg!(ComponentType.radar)	;
	alias ThrusterMsg	= ComponentMsg!(ComponentType.thruster)	;
	alias OtherMsg	= ComponentMsg!(ComponentType.other)	;

}
//---Aliases for easier use of template.
alias Cts	= Messages!(MsgDir.cts)	;
alias Stc	= Messages!(MsgDir.stc)	;





