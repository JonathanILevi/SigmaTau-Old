module console_network.message;

import cst_;

import std.stdio;

public import console_network.enums;


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
		mixin("alias Type = "~(cts?"Cts":"Stc")~componentType.to!string.capitalize~"MsgType"~";");
		
		
		
		/**	A struct to deal with msg data.
			This struct is not required for a console to work, but is convenient to deal with the network messages.
		*/
		struct Msg(Type msgType) {
			alias Type = ComponentMsg!componentType.Type;
			
			//---Always values
			public {
				static if (componentType==ComponentType.other) {
					ubyte	component	= ubyte.max;
				} else {
					ubyte	component	;
				}

				Type	type	;
			}

			//---Other values
			static if (cts) {
				/*thruster set*/
				static if (componentType==ComponentType.thruster && msgType==Type.set) {
					float	power	;
				}
				/*thruster adjust*/
				static if (componentType==ComponentType.thruster && msgType==Type.adjust) {
					float	amount	;
				}
			}
			static if (stc) {
				/*other components*/
				static if (componentType==ComponentType.other && msgType==Type.components) {
					ComponentType[]	components	;
				}
			}

			//---methods
			public {
				/**	Get the network stream byte data
				*/
				ubyte[] byteData() {
					static if (componentType==ComponentType.other) assert(this.component==ubyte.max, "Message Data not set properly");
					assert(this.type == msgType, "Message data not set properly");
				
					static if (stc && componentType==ComponentType.other && msgType==Type.components) {
						return	length
							~	((cast(ubyte*)cast(void*)&this)[0..this.sizeof])	
								[0..$-components.sizeof]	
							~	components.cst!(ubyte[])	;
					}
					else {
						return length~((cast(ubyte*)cast(void*)&this)[0..this.sizeof]);
					}
				}
				/**	Initialize Msg with componentNum
				*/
				static if (componentType!=ComponentType.other) this(ubyte componentNum) {
					this.component = componentNum;
				}
				/**	Create msg with a network streamed byte data
				*/
				this(ubyte[] data) {
					static if (stc && componentType==ComponentType.other && msgType==Type.components) {
						ComponentType[] cmpnts = data[this.bodyLength..$].cst!(ComponentType[]);
						this =	*(	(	data[1..bodyLength]
									~cmpnts.cst!(ubyte[])
								)
								.ptr
								.cst!(void*)
								.cst!(typeof(this)*)	
							);
					}
					else {
						this =	*(	data
								[1..$]
								.ptr
								.cst!(void*)
								.cst!(typeof(this)*)
							);
					}
					assert(this.type == msgType);
					assert(data[0] == length);
				}
				/**	The length of the main body of the msg.
					This length is the length of the non dyamic tail.
					The msg tail is the part of some msgs that changes length depending on the amount of space needed (e.g. a dynamic array of something).
				*/
				static ubyte bodyLength() {
					ubyte calc() {
						import std.traits	: Fields;
						import std.meta	: AliasSeq;
						if (!__ctfe) { assert(false); }
						alias Types = Fields!(typeof(this));
						uint size;
						foreach (T; Types) {
							size+=T.sizeof;
						}
						return size.cst!ubyte;
					}
					
					enum baseSize = calc;
					static if (stc && componentType==ComponentType.other && msgType==Type.components) {
						return baseSize-2-components.sizeof;
					}
					else {
						return baseSize-2;
					}
				}
				/**	The total length of the message with its dynamic tail.
				*/
				ubyte length() {
					static if (stc && componentType==ComponentType.other && msgType==Type.components) {
						return bodyLength+components.length.cst!ubyte&0xff;
					}
					else {
						return bodyLength;
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
		
	}
	//---Aliases for easier use of template.
	mixin ComponentMsg!(ComponentType.radar)	RadarMsg	;
	mixin ComponentMsg!(ComponentType.thruster)	ThrusterMsg	;
	
	mixin ComponentMsg!(ComponentType.other)	OtherMsg	;
	
}
//---Aliases for easier use of template.
mixin Messages!(MsgDir.cts)	Cts	;
mixin Messages!(MsgDir.stc)	Stc	;

























