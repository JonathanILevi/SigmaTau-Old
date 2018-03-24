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
			//---`alias`s to CT data of what this msg data is.
			private {
				mixin("alias ValueBodyData = "~(cts?"Cts":"Stc")~componentType.to!string.toUpperFirst~"MsgBody"~msgType.to!string.toUpperFirst~";");
				mixin("alias hasTail = "~(cts?"Cts":"Stc")~componentType.to!string.toUpperFirst~"MsgHasTail"~msgType.to!string.toUpperFirst~";");
			}
			
			//---Actual data of class
			public {
				//ubyte[2] byteHeadPartial; // In base class.
				ubyte[calcBodyLength!ValueBodyData()] byteBody;
				static if (hasTail) 
					ubyte[] byteTail;
				else
					enum ubyte[] byteTail = [];
			}
				
			//---Value accessors.
			@property {
				override ubyte component	() {	static if (componentType == ComponentType.other) assert(byteHeadPartial[1]==ubyte.max, "For `other` type msgs component must be ubyte.max.")	;
						return byteHeadPartial[0]	;}
				Type type	() {	assert(msgType==byteHeadPartial[1], "class msg type and `byteData` msg type do not match.")	;
						return byteHeadPartial[1].cst!(Type)	;}
				
				// Mixin getters and setters for other (msg specific) values.
				static foreach(Value; ValueBodyData.Values) {
					mixin("Value.Type "~Value.name~"(){ return *((&byteBody[offset!ValueBodyData(Value.name)]).cst!(void*).cst!(Value.Type*));}");
					mixin("void "~Value.name~"(Value.Type value){ *((&byteBody[offset!ValueBodyData(Value.name)]).cst!(void*).cst!(Value.Type*)) = value;}");
				}
			}
			//---Tail accessors
			@property {
				static if (stc && componentType==ComponentType.other && msgType==Type.components) {
					import std.conv : to;
					ComponentType[] components() {
						return byteTail.to!(ComponentType[]);
					}
					void components(ComponentType[] data) {
						byteTail = data.to!(ubyte[]);
					}
				}
			}

			//---Consructors.
			public {
				this () {
					byteHeadPartial[1] = msgType;
					static if (componentType == ComponentType.other) {
						byteHeadPartial[0] = ubyte.max;
					}
				}
				this (ubyte componentNum) {
					byteHeadPartial[1] = msgType	;
					byteHeadPartial[0] = componentNum	;
				}
				this (ubyte[] data) {
					byteHeadPartial = data[1..3];
					byteBody = data[3..3+bodyLength];
					assert(msgType==byteHeadPartial[1], "class msg type and `byteData` msg type do not match")	;
				}
			}

			//---Other methods and properties
			public {
				@property {
					static ubyte bodyLength() {
						return calcBodyLength!ValueBodyData;
					}
					ubyte tailLength() {
						assert(bodyLength+byteTail.length <= ubyte.max, "Msg to long!");
						return byteTail.length.cst!ubyte;
					}
					ubyte contentLength() {//head+tail
						assert(bodyLength+tailLength <= ubyte.max, "Msg to long!");
						return bodyLength+tailLength & 0xFF;
					}
					override {
						ubyte length(){
							return 3+contentLength & 0xFF;
						}
						ubyte[] byteData() {
							return contentLength~byteHeadPartial~byteBody~byteTail;
						}
					}
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
			abstract {
				ubyte	component	();
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





