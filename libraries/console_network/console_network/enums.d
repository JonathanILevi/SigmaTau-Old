/**
These are the basic enums used in network messages.
This and msg structure are the things you need to know to write a console.
*/


module console_network.enums;




/**	Ship Component Types.
	The functionallity of a player ship in SigmaTau is contained almost entirely in the ships "components".
	Componets are things like the ships sensors and engines, but also "vertual" sensors like "tactical" which is actually a ship level interpretation of the other sensors on the ship.
*/
enum ComponentType : ubyte {
	radar	,
	thruster	,

	other	= ubyte.max	,// Sometimes not a legal component but other times is treated as a component.
}



/*	The msg type enums.
	Each component has specified msg types.
*/
public {
	enum CtsRadarMsgType : ubyte {
		read	= 0b0	,
		stream		,
	}
	enum CtsThrusterMsgType : ubyte {
		read	= 0b0	,
		stream		,
		set	= 0b10	,
		adjust		,
	}
	///	The meta component; theses mesages are not sent to a normal component but directly to the ship (generally meta msgs).
	enum CtsOtherMsgType : ubyte {
		getComponents	= 0b0	,
	}	





	enum StcRadarMsgType : ubyte {
		pip	= 0b0	,
	}
	enum StcThrusterMsgType : ubyte {
		power	= 0b0	,
	}
	///	The meta component; theses mesages are not sent from a normal component but directly from the ship (generally meta msgs).
	enum StcOtherMsgType : ubyte {
		components	= 0b0	,
	}
}