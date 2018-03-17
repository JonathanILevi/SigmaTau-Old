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
	void on_read	(Cts.RadarMsg.Read	msg, Console sender)	;
	void on_stream	(Cts.RadarMsg.Stream	msg, Console sender)	;
}
/**	The callback interface for the thruster component.
*/
interface Thruster : Component {
	void on_read	(Cts.ThrusterMsg.Read	msg, Console sender)	;
	void on_stream	(Cts.ThrusterMsg.Stream	msg, Console sender)	;
	void on_set	(Cts.ThrusterMsg.Set	msg, Console sender)	;
	void on_adjust	(Cts.ThrusterMsg.Adjust	msg, Console sender)	;
}





