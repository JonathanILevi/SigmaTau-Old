module loose_.network_var_.network_var_;
import commonImports;

import std.traits;


enum Read	;
enum Write	;
struct Sync {
	uint	valueId	;
}

template Owner(bool isOwner) {
	static if (isOwner)
		mixin("alias Owner = Write;");
	else 
		mixin("alias Owner = Read;");
}
////mixin template Owner(string name, bool isOwner) {
////	static if (isOwner) {
////		mixin("alias "name~"=Read");
////	else 
////		mixin("alias "name~"=Read");
////}
mixin template NetworkVar() {
	static foreach(var; getSymbolsByUDA!(this, Sync))) {
		enum varName	= __traits(identifier, var)[1..$];
		enum varId	= getUDAs(var, Sync)[0].valueId;
		@property auto mixin(varName)() {
			return mixin("this._"~varName);
		}
		static if (hasUDA!(this,Write)) {
			static if (!is(typeof(mixin("this._networkVar_"~varId~"_changed")))) {
				bool mixin("this._networkVar_"~varId~"_changed") = false;
			}
			@property void mixin(varName)(typeof(Sync) n) {
				mixin("this._"~varName)	= n	;
				mixin("this._networkVar_"~varId~"_changed")	= true	;
			}
		}
	}
	void networkVar_update(void delegate(ubyte[]) msg_callback, ubyte[][] msgs) {
		pragma(inline, true) ubyte[] serialize(uint valueId)() {
			
		}
		pragma(inline, true) void deserialize(ubyte[] msg) {
			
		}
		
		foreach (msg; msgs) {
			deserialize(msg);
		}
		static foreach(var; getSymbolsByUDA!(this, Sync))) {
			static if (hasUDA!(this,Write)) {
				enum varName	= __traits(identifier, var)[1..$];
				enum varId	= getUDAs(var, Sync)[0].valueId;
				if (bool mixin("this._networkVar_"~varId~"_changed")) {
					msg_callback(serialize!varId);
					mixin("this._networkVar_"~varId~"_changed") = false;
				}
			}
		}
	}
}


