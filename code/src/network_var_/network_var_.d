module loose_.network_var_.network_var_;


enum Read	;
enum Write	;
enum SplitArray	;
struct Sync {
	ubyte	valueId	;
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
				mixin("size_t _networkVar_"~mixin(_networkVar_private_varIdStr)~"_added = 0;");
				mixin("size_t[] _networkVar_"~mixin(_networkVar_private_varIdStr)~"_removed = [];");
				@property mixin("void "~mixin(_networkVar_private_varName)~"_add(typeof(*var.ptr) n) {
					_"~mixin(_networkVar_private_varName)~"	~= n	;
					_networkVar_"~mixin(_networkVar_private_varIdStr)~"_added	+= 1	;
				}");
				@property mixin("void "~mixin(_networkVar_private_varName)~"_remove(typeof(*var.ptr) n) {
					size_t i = _"~mixin(_networkVar_private_varName)~".countUntil(n);
					_"~mixin(_networkVar_private_varName)~" = _"~mixin(_networkVar_private_varName)~".remove(i);
					_networkVar_"~mixin(_networkVar_private_varIdStr)~"_removed	~= i;
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
		enum Event : ubyte {
			add	,
			remove	,
			update	,
		}
		pragma(inline, true) ubyte[] serialize(uint valueId)() {
			return [9,9,9,9];
		}
		pragma(inline, true) void deserialize(ubyte[] msg) {
			msg.log;
		}
		
		foreach (msg; msgs) {
			deserialize(msg);
		}
		static foreach(var; getSymbolsByUDA!(typeof(this), Sync)) {
			static if (hasUDA!(var,Write)) {
				static if (hasUDA!(var,SplitArray)) {
					foreach (added; 0..mixin("this_._networkVar_"~mixin(_networkVar_private_varIdStr)~"_added")) {
						msg_callback([mixin(_networkVar_private_varId), Event.add]);
					}
					mixin("this_._networkVar_"~mixin(_networkVar_private_varIdStr)~"_added") = 0;
					foreach (removed; mixin("this_._networkVar_"~mixin(_networkVar_private_varIdStr)~"_removed")) {
						msg_callback([mixin(_networkVar_private_varId), Event.remove, (cast(ubyte)removed)]);
					}
					mixin("this_._networkVar_"~mixin(_networkVar_private_varIdStr)~"_removed") = [];
					
					foreach (i, entity; mixin("this_._"~mixin(_networkVar_private_varName))) {
						entity.networkVar_update((msg){
							ubyte[] header = [mixin(_networkVar_private_varId), Event.update,(cast(ubyte)i)];
							msg_callback(header~msg);
						},[]);
					}
				}
				else {
					if (mixin("this_._networkVar_"~mixin(_networkVar_private_varIdStr)~"_changed")) {
						msg_callback([mixin(_networkVar_private_varId)]~serialize!(mixin(_networkVar_private_varId)));
						mixin("this_._networkVar_"~mixin(_networkVar_private_varIdStr)~"_changed") = false;
					}
				}
			}
		}
	}
}


