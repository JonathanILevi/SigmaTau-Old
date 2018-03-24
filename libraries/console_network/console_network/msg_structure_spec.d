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

	////private template MsgValues(T...) {
	////    alias MsgValues = AliasSeq!(T);
	////}
	template MsgValue(T, string valueName) {
		alias Type	= T	;
		enum name	= valueName	;
	}
	private alias MV=MsgValue;

	////alias CtsRadarMsgBodyRead	= AliasSeq!(		);
	////alias CtsRadarMsgBodyStream	= AliasSeq!(		);
	////            
	////alias CtsThrusterMsgBodyRead	= AliasSeq!(		);
	////alias CtsThrusterMsgBodyStream	= AliasSeq!(		);
	////alias CtsThrusterMsgBodySet	= AliasSeq!(	MV!(float,"power")	,);
	////alias CtsThrusterMsgBodyAdjust	= AliasSeq!(	MV!(float,"amount")	,);
	////            
	////alias CtsOtherMsgBodyGetComponents	= AliasSeq!(		);
	////
	////
	////alias StcRadarMsgBodyPip	= AliasSeq!(	MV!(float[2],"polarPos")	,
	////        MV!(ubyte,"strength")	,);
	////alias StcThrusterMsgBodyPower	= AliasSeq!(	MV!(float,"power")	,);
	////            
	////alias StcOtherMsgBodyComponents	= AliasSeq!(		);

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
	////ubyte offset(AliasSeq!(T) msgValues)(MsgValue msgValue) {
	////    import std.algorithm.iteration;
	////    import std.algorithm.searching;
	////    import std.typecons : No;
	////    return	msgValues
	////            .until(msgValue, No.openRight)
	////            .map!"a.Type.sizeof"
	////            .sum
	////            .cst!ubyte;
	////}


	////enum CtsRadarMsgBodyRead	: ubyte {			};
	////enum CtsRadarMsgBodyStream	: ubyte {			};
	////                
	////enum CtsThrusterMsgBodyRead	: ubyte {			};
	////enum CtsThrusterMsgBodyStream	: ubyte {			};
	////enum CtsThrusterMsgBodySet	: ubyte {	power	= float.sizeof	,};
	////enum CtsThrusterMsgBodyAdjust	: ubyte {	amount	= float.sizeof	,};
	////                
	////enum CtsOtherMsgBodyGetComponents	: ubyte {		,};
	////
	////
	////enum StcRadarMsgBodyPip	: ubyte {			};
	////                
	////enum StcThrusterMsgBodyPower	: ubyte {			};
	////                
	////enum StcOtherMsgBodyComponents	: ubyte {			};



	////ubyte length(T)() if	(	is	(T==CtsRadarMsgBodyRead	)
	////        && is	(T==CtsRadarMsgBodyStream	)
	////        && is	(T==CtsThrusterMsgBodyRead	)
	////        && is	(T==CtsThrusterMsgBodyStream	)
	////        && is	(T==CtsThrusterMsgBodySet	)
	////        && is	(T==CtsThrusterMsgBodyAdjust	)
	////        && is	(T==CtsOtherMsgBodyGetComponent	)
	////
	////        && is	(T==StcRadarMsgBodyPip	)
	////        && is	(T==StcThrusterMsgBodyPower	)
	////        && is	(T==StcOtherMsgBodyComponents	)
	////    ) {
	////
	////    import std.algorithm.iteration;
	////    return	__traits(allMembers, T)
	////            .map!"__traits(getMember, T, a).cst!ubyte"
	////            .sum
	////            .cst!ubyte;
	////}
	////ubyte offset(T)(T value) if	(	is	(T==CtsRadarMsgBodyRead	)
	////        && is	(T==CtsRadarMsgBodyStream	)
	////        && is	(T==CtsThrusterMsgBodyRead	)
	////        && is	(T==CtsThrusterMsgBodyStream	)
	////        && is	(T==CtsThrusterMsgBodySet	)
	////        && is	(T==CtsThrusterMsgBodyAdjust	)
	////        && is	(T==CtsOtherMsgBodyGetComponent	)
	////                
	////        && is	(T==StcRadarMsgBodyPip	)
	////        && is	(T==StcThrusterMsgBodyPower	)
	////        && is	(T==StcOtherMsgBodyComponents	)
	////    ) {
	////
	////    import std.algorithm.iteration;
	////    import std.algorithm.searching;
	////    import std.conv : to;
	////    import std.typecons : No;
	////    return	__traits(allMembers, T)
	////            .until(value.to!string, No.openRight)
	////            .map!"__traits(getMember, T, a).cst!ubyte"
	////            .sum
	////            .cst!ubyte;
	////}
}


