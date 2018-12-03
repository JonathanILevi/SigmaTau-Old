module galactic_.logic_world_.entities_._basic_code_;
import commonImports;

import loose_.vec_math_;

public import galactic_.logic_world_.entities_	.entity_	;

abstract class NotFlatEntity : Entity {
	public {
		final override @property bool flat() { return false; }
	}
	package(galactic_.logic_world_) {
		this(float[2] pos=[0,0],float ori=0) {
			super(pos,ori);
		}
	}
	protected {
		override @property {
			float[2]	virtualPos()	{ return _pos	; }
			void	virtualPos(float[2] n)	{ _pos = n	; }
			float	virtualOri()	{ return _ori	; }
			void	virtualOri(float n)	{ _ori = n	; }
			float[2]	virtualVel()	{ return _vel	; }
			void	virtualVel(float[2] n)	{ _vel = n	; }
			float	virtualAnv()	{ return _anv	; }
			void	virtualAnv(float n)	{ _anv = n	; }
		}
	}
	private {
		float[2]	_pos	;
		float	_ori	;
		float[2]	_vel	;
		float	_anv	;
	}
}

mixin template EntityTemplate() {
	protected {
		override void callSubInits() {
			callSub!"init";
		}
		override void callSubUpdates() {
			callSub!"update";
		}
	}
	private {
		void callSub(string prefix)() {
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
			static foreach (mem; __traits(allMembers, typeof(this))) {
				static if (mem.startsWith("late2_"~prefix~'_')) {
					pragma(msg, mem);
					__traits(getMember, this, mem)();
				}
			}
		}
	}
}

mixin template PhysicsTemplate() {
	package(galactic_.logic_world_) {
		void giveThrust(float[2] thrust) {
			float[2] n;
			n[] = vel[] + thrust.rotate(this.ori)[];
			vel = n;
		}
		void giveTorque(float torque) {
			anv = anv + torque;
		}
	}
	protected {
		void late_update_physics() {
			float[2] n;
			n[]	= pos[]+vel[]	;
			pos	= n	;
			ori	= ori+anv	;
		}
	}
}




























