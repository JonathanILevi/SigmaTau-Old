module galactic_.logic_world_.entities_.ship_;
import commonImports;

import loose_	.vec_math_	;
import galactic_.logic_world_.entities_	._basic_code_	;

class Ship : FlatEntity {
	override @property EntityType type() {return EntityType.ship;}
	
	this() {
		super();
	}
	this(float[2] pos,float ori, float[2] vel,float anv,) {
		super(pos, ori);
		this.vel	= vel	;
		this.anv	= anv	;
	}
	
	mixin EntityTemplate	;
	mixin PhysicsTemplate	;
}

