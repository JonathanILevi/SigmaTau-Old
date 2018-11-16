module galactic_.logic_world_.entities_.entities_;
import commonImports;

import loose_	.vec_math_	;
import galactic_.logic_world_.entities_	._basic_code_	;



class StarSystem : NotFlatEntity {
	override @property EntityType type() {return EntityType.starSystem;}
	
	this() {
		super();
	}
	
	mixin EntityTemplate	;
}


class Sun : FlatEntity {
	override @property EntityType type() {return EntityType.sun;}
	
	this() {
		super();
	}
	
	mixin EntityTemplate	;
}
class Planet : FlatEntity {
	override @property EntityType type() {return EntityType.planet;}
	
	this() {
		super();
	}
	
	mixin EntityTemplate	;
}




class Asteroid : FlatEntity {
	override @property EntityType type() {return EntityType.asteroid;}
	
	this(float[2] pos=[0,0],float ori=0, float[2] vel=[0,0],float anv=0,) {
		super(pos, ori);
		this.vel	= vel	;
		this.anv	= anv	;
	}
	
	mixin EntityTemplate	;
	mixin PhysicsTemplate	;
}




