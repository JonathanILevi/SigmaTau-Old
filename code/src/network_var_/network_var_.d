module loose_.network_var_.network_var_;


enum Read	;
enum Write	;
enum SplitArray	;
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
	private import std.traits;
	private import std.algorithm : countUntil;
	private import std.conv : to;
	enum _networkVar_private_varName	= q{__traits(identifier, var)[1..$]};
	enum _networkVar_private_varId	= q{getUDAs!(var, Sync)[0].valueId};
	enum _networkVar_private_varIdStr	= _networkVar_private_varId~".to!string";
	static foreach(var; getSymbolsByUDA!(typeof(this), Sync)) {
		static assert(__traits(identifier, var)[0]=='_');
		@property mixin("auto "~mixin(_networkVar_private_varName)~"() {
			return _"~mixin(_networkVar_private_varName)~";
		}");
 		static if (hasUDA!(var,Write)) {
			static if (hasUDA!(var,SplitArray)) {
				mixin("typeof(var) _networkVar_"~mixin(_networkVar_private_varIdStr)~"_added = new typeof(*var.ptr)[0];");
				mixin("typeof(var) _networkVar_"~mixin(_networkVar_private_varIdStr)~"_removed = new typeof(*var.ptr)[0];");
				@property mixin("void "~mixin(_networkVar_private_varName)~"_add(typeof(*var.ptr) n) {
					_"~mixin(_networkVar_private_varName)~"	~= n	;
					_networkVar_"~mixin(_networkVar_private_varIdStr)~"_added	~= n	;
				}");
				@property mixin("void "~mixin(_networkVar_private_varName)~"_remove(typeof(*var.ptr) n) {
					_"~mixin(_networkVar_private_varName)~".remove(_"~mixin(_networkVar_private_varName)~".countUntil(n));
					_networkVar_"~mixin(_networkVar_private_varIdStr)~"_removed	~= n	;
				}");
			}
			else {
				static if (!is(typeof(mixin("_networkVar_"~mixin(_networkVar_private_varIdStr)~"_changed")))) {
					mixin("bool _networkVar_"~mixin(_networkVar_private_varIdStr)~"_changed = false;");
				}
				@property mixin("void "~mixin(_networkVar_private_varName)~"(typeof(var) n) {
					if ("~mixin(_networkVar_private_varName)~"!=n) {
						_"~mixin(_networkVar_private_varName)~"	= n	;
						_networkVar_"~mixin(_networkVar_private_varIdStr)~"_changed	= true	;
					}
				}");
			}	
		}
	}
	void networkVar_update(void delegate(ubyte[]) msg_callback, ubyte[][] msgs) {
		_networkVar_private_update(this, msg_callback, msgs);
	}
	static void _networkVar_private_update(typeof(this) this_, void delegate(ubyte[]) msg_callback, ubyte[][] msgs) {
		pragma(inline, true) ubyte[] serialize(uint valueId)() {
			return [0,1,2,5];
		}
		pragma(inline, true) void deserialize(ubyte[] msg) {
			
		}
		
		foreach (msg; msgs) {
			deserialize(msg);
		}
		static foreach(var; getSymbolsByUDA!(typeof(this), Sync)) {
			static if (hasUDA!(var,Write)) {
				static if (hasUDA!(var,SplitArray)) {
				}
				else {
					if (mixin("this_._networkVar_"~mixin(_networkVar_private_varIdStr)~"_changed")) {
						msg_callback(serialize!(mixin(_networkVar_private_varId)));
						mixin("this_._networkVar_"~mixin(_networkVar_private_varIdStr)~"_changed") = false;
					}
				}
			}
		}
	}
}


