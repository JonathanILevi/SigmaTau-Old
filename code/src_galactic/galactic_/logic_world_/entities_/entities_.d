module galactic_.logic_world_.entities_.entities_;
import commonImports;

import loose_	.vec_math_	;
import galactic_.logic_world_.entities_	._basic_code_	;



class StarSystem : NotFlatEntity {
	package(galactic_.logic_world_) {
		this() {
			super();
		}
	}
	
	mixin EntityTemplate	;
}


class Sun : FlatEntity {
	package(galactic_.logic_world_) {
		this() {
			super();
		}
	}
	
	mixin EntityTemplate	;
}
class Planet : FlatEntity {
	package(galactic_.logic_world_) {
		this() {
			super();
		}
	}
	
	mixin EntityTemplate	;
}

class Asteroid : FlatEntity {
	package(galactic_.logic_world_) {
		this(float[2] pos=[0,0],float ori=0, float[2] vel=[0,0],float anv=0,) {
			super(pos, ori);
			this.vel	= vel	;
			this.anv	= anv	;
		}
	}
	
	mixin EntityTemplate	;
	mixin PhysicsTemplate	;
}




