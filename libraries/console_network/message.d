





/**	Ship Component Types.
	The functionallity of a player ship in SigmaTau is contained almost entirely in the ships "components".
	Componets are things like the ships sensors and engines, but also "vertual" sensors like "tactical" which is actually a ship level interpretation of the other sensors on the ship.
*/
enum ComponentType : ubyte {
	radar	,
	thruster	,
}







/**	The namespace with all the "Console to Ship" specifice types, data, and code.
*/
static class Cts {
	
	/**	Msg code specific to a type of componet.
	*/
	template Msg(ComponentType componentType) {
		// Adds an alias for the msg type for this component.
		import std.string : capitalize;
		alias Type = mixin(componentType.to!string[0].capitalize~componentType.to!string[1..$]~"MsgType"~";");
		
		/**	A struct to deal with msg data.
			This struct is not required for a console to work, but is convenient to deal with the network messages.
		*/
		struct Msg(Type type) {
			alias Type = Type;
			
			//---Always values
			public {
				ubyte	component	;
				Type	type	;
			}

			//---Other values
			public {
				/*thruster set*/
				static if (componentType==ComponentType.thruster && type==Type.set) {
					float	power	;
				}
				/*thruster adjust*/
				static if (componentType==ComponentType.thruster && type==Type.adjust) {
					float	amount	;
				}
			}

			//---methods
			public {
				ubyte[] byteData() {
					assert(this.type == type);
					return length~((cast(ubyte*)cast(void*)&this)[0..this.sizeof]);
				}
				this(ubyte[] data) {
					this = *(cast(typeof(this)*)cast(void*)data[1..$].ptr);
					assert(this.type == type);
					assert(data[0] == length);
				}
				ubyte length() {
					return this.sizeof-2;
				}
			}
		}
	}

	
	/**	Msg struct for msgs that are not attached to any compont.
		(component -1/.max)
		This struct is not required for a console to work, but is convenient to deal with the network messages.
	*/
	struct OtherMsg(OtherMsgType type) {
		alias Type = OtherMsgType;
		//---Always values
		public {
			private ubyte	component = ubyte.max	;// Always -1/max because that is what defines the msg as type other.
			Type	type	;
		}

		//---Other values
		public {
		}

		//---methods
		public {
			ubyte[] byteData() {
				assert(this.type == type);
				return length~((cast(ubyte*)cast(void*)&this)[0..this.sizeof]);
			}
			this(ubyte[] data) {
				this = *(cast(typeof(this)*)cast(void*)data[1..$].ptr);
				assert(this.type == type);
				assert(data[0] == length);
			}
			ubyte length() {
				return this.sizeof-2;
			}
		}
	}

	
	
	/*	The msg type enums.
		Each component has specified msg types.
	*/
	public {
		enum RadarMsgType {
			read	= 0b0	,
			stream		,
		}
		enum ThrusterMsgType {
			read	= 0b0	,
			stream		,
			set	= 0b10	,
			adjust		,
		}
		///	Msgs not send to a component but directly to the ship (generally meta msgs).
		enum OtherMsgType : ubyte {
			getComponents	= 0b0	,
		}
	}
	
}










/**	The namespace with all the "Ship to Console" specifice types, data, and code.
*/
static class Stc {

	/**	Msg code specific to a type of componet.
	*/
	template Msg(ComponentType componentType) {
		// Adds an alias for the msg type for this component.
		import std.string : capitalize;
		alias Type = mixin(componentType.to!string[0].capitalize ~ componentType.to!string[1..$] ~ "MsgType;");

		/**	A struct to deal with msg data.
		This struct is not required for a console to work, but is convenient to deal with the network messages
		*/
		struct Msg(Type type) {
			//---Always values
			public {
				ubyte	component	;
				Type	type	;
			}

			//---Other values
			public {
				/*thruster set*/
				static if (componentType==ComponentType.thruster && type==Type.set) {
					float	power	;
				}
				/*thruster adjust*/
				static if (componentType==ComponentType.thruster && type==Type.adjust) {
					float	amount	;
				}
			}

			//---methods
			public {
				ubyte[] byteData() {
					assert(this.type == type);
					return length~((cast(ubyte*)cast(void*)&this)[0..this.sizeof]);
				}
				this(ubyte[] data) {
					this = *(cast(typeof(this)*)cast(void*)data[1..$].ptr);
					assert(this.type == type);
					assert(data[0] == length);
				}
				ubyte length() {
					return this.sizeof-2;//-2 for msg header
				}
			}
		}
	}

	
	/**	Msg struct for msgs that are not attached to any compont.
		(component -1/.max)
		This struct is not required for a console to work, but is convenient to deal with the network messages.
	*/
	struct OtherMsg(OtherMsgType type) {
		alias Type = OtherMsgType;
		//---Always values
		public {
			private ubyte	component = ubyte.max	;// Always -1/max because that is what defines the msg as type other.
			Type	type	;
		}

		//---Other values
		public {
		}

		//---methods
		public {
			ubyte[] byteData() {
				assert(this.type == type);
				return length~((cast(ubyte*)cast(void*)&this)[0..this.sizeof]);
			}
			this(ubyte[] data) {
				this = *(cast(typeof(this)*)cast(void*)data[1..$].ptr);
				assert(this.type == type);
				assert(data[0] == length);
			}
			ubyte length() {
				return this.sizeof-2;
			}
		}
	}

	
	
	/*	The msg type enums.
		Each component has specified msg types.
	*/
	enum RadarMsgType {
		pip	= 0b0	,
	}
	enum ThrusterMsgType {
		power	=0b0	,
	}

}





























