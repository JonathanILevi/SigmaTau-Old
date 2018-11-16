module galactic_msg_.galactic_msg_;
import commonImports;

import loose_.network_var_	.network_var_;


class Entity(bool server) {
	alias Server	= Owner!(server);
	alias Client	= Owner!(!server);
	
	@Sync(0) @Server {
		float[2]	_pos	;
		float	_ori	;
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





