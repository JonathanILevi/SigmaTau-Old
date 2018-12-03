module galactic_msg_.galactic_msg_;
import commonImports;

import netize;
import xserial.attribute;

class Entity(bool server) {
	alias Server	= Owner!(server);
	alias Client	= Owner!(!server);
	
	/***@Sync(0) @Server*/ @Include {
		float[2]	/***_*/pos	;
		float	/***_*/ori	;
		float[2]	/***_*/vel	;
		float	/***_*/anv	;
	}
	
	/***mixin Netize;*/
}
class World(bool server) {
	alias Server	= Owner!(server);
	alias Client	= Owner!(!server);
	
	@Server {
		@Sync(0) /***@SplitArray*/@Change @Length!uint	Entity!server[]	_entities	;
	}
	@Server @Client {
		@Sync(1) {
			float[2]	_vel	;
			float	_anv	;
		}
	}
	
	mixin Netize;
	
	void entities_add(Entity!server e) {
		entities = _entities~e;
	}
	void entities_remove(Entity!server e) {
		import std.algorithm;
		entities = _entities.remove(entities.countUntil(e));
	}
	
	pragma(inline, true) ubyte[][] update(ubyte[][] msgs, void delegate(string) error=null) { 
		return this.netizeUpdate(msgs,error);
	}
}





