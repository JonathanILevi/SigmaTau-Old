/**
Callback interfaces for components.

Component classes with implement these for `networking` to use for callbacks.
*/
module networking.components;


import console_network.message	;
import console	;


/**	The parent interface for for components.
*/
abstract interface Component {
	@property ComponentType type();
}



/**	The callback interface for the radar component.
*/
interface Radar : Component {
	private alias CMsg = Cts.ComponentMsg!(ComponentType.radar);
	
	void on_read	(CMsg.Msg!(CMsg.Type.read)	msg, Console sender)	;
	void on_stream	(CMsg.Msg!(CMsg.Type.stream)	msg, Console sender)	;
}
/**	The callback interface for the thruster component.
*/
interface Thruster : Component {
	private alias CMsg = Cts.ComponentMsg!(ComponentType.thruster);

	void on_read	(CMsg.Msg!(CMsg.Type.read)	msg, Console sender)	;
	void on_stream	(CMsg.Msg!(CMsg.Type.stream)	msg, Console sender)	;
	void on_set	(CMsg.Msg!(CMsg.Type.set)	msg, Console sender)	;
	void on_adjust	(CMsg.Msg!(CMsg.Type.adjust)	msg, Console sender)	;
}





