module galactic_.logic_world_.entities_._basic_code_;
import commonImports;

import loose_.vec_math_;

public import galactic_.logic_world_.entities_	.entity_	;

abstract class NotFlatEntity : Entity {
	this(float[2] pos=[0,0],float ori=0) {
		super(pos,ori);
	}
	private {
		float[2]	_pos	;
		float	_ori	;
	}
	override @property {
		float[2]	virtualPos()	{ return _pos	; }
		void	virtualPos(float[2] n)	{ _pos = n	; }
		float	virtualOri()	{ return _ori	; }
		void	virtualOri(float n)	{ _ori = n	; }
	}
}

mixin template EntityTemplate() {
	override protected void callSubInits() {
		callSub!"init";
	}
	override protected void callSubUpdates() {
		callSub!"update";
	}
	private void callSub(string prefix)() {
		import std.traits;
		static foreach (mem; __traits(allMembers, typeof(this))) {
			static if (mem.startsWith(prefix~'_')) {
				pragma(msg, mem);
				__traits(getMember, this, mem)();
			}
		}
		static foreach (mem; __traits(allMembers, typeof(this))) {
			static if (mem.startsWith("late_"~prefix~'_')) {
				pragma(msg, mem);
				__traits(getMember, this, mem)();
			}
		}
	}
}

mixin template PhysicsTemplate() {
	void late_update_physics() {
	////	pos[]	= pos[]+vel[]	;
	////	ori	= ori+anv	;
	}
	
	float[2]	vel	;
	float	anv	;

	void giveThrust(float[2] thrust) {
		this.vel[] += thrust.rotate(this.ori)[];
	}
	void giveTorque(float torque) {
		this.anv += torque;
	}
}




























