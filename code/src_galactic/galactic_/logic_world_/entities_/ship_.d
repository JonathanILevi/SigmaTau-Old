module galactic_.logic_world_.entities_.ship_;
import commonImports;

import loose_	.vec_math_	;
import galactic_.logic_world_.entities_	._basic_code_	;

class Ship : FlatEntity {
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

