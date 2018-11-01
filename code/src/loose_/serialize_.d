module loose_.serialize_;
import commonImports;

public import xserial.attribute;
import xserial	:	ser	= serialize	;
import xserial	:	deser	= deserialize	;

auto serialize(alias group, T)(T data) {
	data.ser!(group, Endian.littleEndian, ubyte);
}
auto deserialize(alias group, T)(const(ubyte[]) data) {
	data.deser!(T, group, Endian.littleEndian, ubyte);
}
auto serialize(T)(T data) {
	data.ser!(null, Endian.littleEndian, ubyte);
}
auto deserialize(T)(const(ubyte[]) data) {
	data.deser!(T, null, Endian.littleEndian, ubyte);
}



