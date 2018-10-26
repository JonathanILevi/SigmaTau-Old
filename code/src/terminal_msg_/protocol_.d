module terminal_msg_.protocol_;
import commonImports;

import loose_	.serialize_	;

public {
	struct State {
		ubyte id;
	}
	struct StateChanged {
		ubyte id;
	}
	struct SplitArray {
		ubyte addId	;
		ubyte removeId	;
		ubyte updateId	;
	}
	struct Settable {
		ubyte id;
	}
	
	struct Locatior {
		
	}
}

mixin template EntityTemplate() {
	@State(0) {
		float[2]	_pos	;
		float	_ori	;
	}
	@StateChanged(0) {
		bool	_changed	;
	}
	
	@property {
		float[2] pos() {
			return _pos;
		}
		void pos(float[2] n) {
			_pos = n;
			_changed	= true	;
		}
		float ori() {
			return _ori;
		}
		void ori(float n) {
			_ori = n;
			_changed	= true	;
		}
	}
}


private mixin template MsgsTemplate() {
	const(ubyte)[][] getUpdateMsg() {
		import std.traits;
		static foreach (ubyte id; 0..256) {
			static if (hasUDA!(this,State(id))) {
				alias changed = __traits(getMember,getSymbolsByUDA!(this,StateChanged(id))[0])
				if (changed) {
					ubyte[] data = id ~ __traits(getMember,this, mem).serialize!(State(id));
					changed = false;
				}
			}
		}
	}
}


mixin template MetaRadarTemplate(Entity) {
	@SplitArray(0,1,2) {
		Entity[]	_entities	;
		Entity[]	_added	= []	;
		Entity[]	_removed	= []	;
	}
	
	@property Entity[] entities() {
		return _entities~[];	// Shallow copy the array, so that only the data in the `Entity` will be affected.
			// It would be far better to just pass an const(headconst(Entity)[]) but D does not support this.
	}
	void addEntity(Entity entity) {
		_entities	~= entity	;
		_added	~= entity	;
	}
	void removeEntity(Entity entity) {
		_entities	= _entities.remove(_entities.countUntil(entity))	;
		_removed	~= entity	;
	}
}
mixin template MetaMoveTemplate() {
	@State(0) @Settable(0) {
		float	_forward	;
		float	_strafe	;
		bool	_changed	= false;
	}
	
	@property {
		float forward() {
			return _forward;
		}
		void forward(float n) {
			_forward	= n	;
			_changed	= true	;
		}
		float strafe() {
			return _strafe;
		}
		void strafe(float n) {
			_strafe	= n	;
			_changed	= true	;
		}
	}
}




