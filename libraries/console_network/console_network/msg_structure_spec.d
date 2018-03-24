/**
Console network private data.

This is the data for the structure of msgs.  This data is used to construct the msg classes is `message.d`.
*/

module console_network.msg_structure_spec;

import cst_;

string toUpperFirst(string value) {
	import std.ascii : toUpper;
	return value[0].toUpper~value[1..$];
}


/*	Msg structure spec.
*/
public {
	import std.meta : AliasSeq;

	//---For msg body.
	public {
		public {
			template MsgValue(T, string valueName) {
				alias Type	= T	;
				enum name	= valueName	;
			}
			private alias MV=MsgValue;
		}
		public {
			static struct CtsRadarMsgBodyRead { static:
				alias Values = AliasSeq!(		);
			}
			static struct CtsRadarMsgBodyStream { static:
				alias Values = AliasSeq!(		);
			}

			static struct CtsThrusterMsgBodyRead { static:
				alias Values = AliasSeq!(		);
			}
			static struct CtsThrusterMsgBodyStream { static:
				alias Values = AliasSeq!(		);
			}
			static struct CtsThrusterMsgBodySet { static:
				alias Values = AliasSeq!(	MV!(float,"power")	,);
			}
			static struct CtsThrusterMsgBodyAdjust { static:
				alias Values = AliasSeq!(	MV!(float,"amount")	,);
			}

			static struct CtsOtherMsgBodyGetComponents { static:
				alias Values = AliasSeq!(		);
			}


			static struct StcRadarMsgBodyPip { static:
				alias Values = AliasSeq!(	MV!(float[2],"polarPos")	,
											MV!(ubyte,"strength")	,);
			}
			static struct StcThrusterMsgBodyPower { static:
				alias Values = AliasSeq!(	MV!(float,"power")	,);
			}

			static struct StcOtherMsgBodyComponents { static:
				alias Values = AliasSeq!(		);
			}
		}


		//---Functions to calculate constants of msgs
		public {
			ubyte calcBodyLength(T)() if	(	is	(T==CtsRadarMsgBodyRead	)
					|| is	(T==CtsRadarMsgBodyStream	)
					|| is	(T==CtsThrusterMsgBodyRead	)
					|| is	(T==CtsThrusterMsgBodyStream	)
					|| is	(T==CtsThrusterMsgBodySet	)
					|| is	(T==CtsThrusterMsgBodyAdjust	)
					|| is	(T==CtsOtherMsgBodyGetComponents	)
					|| is	(T==StcRadarMsgBodyPip	)
					|| is	(T==StcThrusterMsgBodyPower	)
					|| is	(T==StcOtherMsgBodyComponents	)
				){

				uint output;
				foreach (Value; T.Values) {
					output+=Value.Type.sizeof;
				}
				return output.cst!ubyte;
			}
			ubyte offset(T)(string name) if	(	is	(T==CtsRadarMsgBodyRead	)
					|| is	(T==CtsRadarMsgBodyStream	)
					|| is	(T==CtsThrusterMsgBodyRead	)
					|| is	(T==CtsThrusterMsgBodyStream	)
					|| is	(T==CtsThrusterMsgBodySet	)
					|| is	(T==CtsThrusterMsgBodyAdjust	)
					|| is	(T==CtsOtherMsgBodyGetComponents	)
					|| is	(T==StcRadarMsgBodyPip	)
					|| is	(T==StcThrusterMsgBodyPower	)
					|| is	(T==StcOtherMsgBodyComponents	)
				){

				uint output;
				foreach (Value; T.Values) {
					output+=Value.Type.sizeof;
					if (Value.name==name) break;
				}
				return output.cst!ubyte;
			}
		}
	}
	
	
	
	//---For msg tail
	public {
		enum bool CtsRadarMsgHasTailRead	= false	;
		enum bool CtsRadarMsgHasTailStream	= false	;
		enum bool CtsThrusterMsgHasTailRead	= false	;
		enum bool CtsThrusterMsgHasTailStream	= false	;
		enum bool CtsThrusterMsgHasTailSet	= false	;
		enum bool CtsThrusterMsgHasTailAdjust	= false	;
		enum bool CtsOtherMsgHasTailGetComponents	= false	;
		
		enum bool StcRadarMsgHasTailPip	= false	;
		enum bool StcThrusterMsgHasTailPower	= false	;
		enum bool StcOtherMsgHasTailComponents	= true	;
	}
	
}


