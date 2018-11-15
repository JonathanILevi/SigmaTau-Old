module galactic_msg_.galactic_msg_;
import commonImports;

import loose_.network_var_	.network_var_;


class Entity(bool server) {
	private {
		enum both	= Access.both	;
		static if (server) {
			enum server	= Access.write	;
			enum client	= Access.read	;
		}
		else {
			enum server	= Access.read	;
			enum client	= Access.write	;
		}
	}
	@Sync(0, server) Entity[] {
		float[2]	pos	;
		float	ori	;
	}
	
	mixin NetworkVar;
}
class World(bool server) {
	alias Server	= Owner!(server);
	alias Client	= Owner!(!server);
	
	@Server {
		@Sync(0) @SplitArray	Entity[]	_entities	;
	}
	@Server @Client {
		@Sync(1) {
			float[2]	_vel	;
			float	_anv	;
		}
	}
	
	mixin NetworkVar;
}





