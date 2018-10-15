module galactic_.world_.entity_;

import std.experimental.logger;
import cst_;

class Entity {
	this() {
		assert(nextId<=ushort.max);
		id = nextId++;
	}
	this(	float[2]	pos	,
		float	ori	,
		float[2]	vel	,
		float	anv	,) {
		
		this();
		
		this.pos	= pos	;
		this.ori	= ori	;
		this.vel	= vel	;
		this.anv	= anv	;
	}
	this();
	float[2]	pos	;
	float	ori	;
	float[2]	vel	;
	float	anv	;
			
	ushort	id	;
	
	import galactic_.game_logic_.controller_:Controller;
	Controller controller = null;
	
	static ushort nextId;
}

