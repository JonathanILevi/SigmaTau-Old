module loose_.serialize_;

import xserial : Ser = Serializer;
public import xserial.attribute				;

template Serizalizer(UDAs...) {
	ubyte[] serialize(T)(T value) {
		return Ser!(Exclude,Endian.littleEndian,Length!ubyte,UDAs).serialize(value);
	}
	T deserialize(T)(T value, const(ubyte)[] data) {
		return Ser!(Exclude,Endian.littleEndian,Length!ubyte,UDAs).deserialize(value, data);
	}
	T deserialize(T)(const(ubyte)[] data) {
		return Ser!(Exclude,Endian.littleEndian,Length!ubyte,UDAs).deserialize!T(data);
	}
}
alias serialize = Serizalizer!().serialize;
alias deserialize = Serizalizer!().deserialize;


