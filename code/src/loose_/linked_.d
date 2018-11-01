module linked_;


class Node(T) {
	Node!T* next;

	T payload;
	alias value = payload;
	
	alias payload this;
}

unittest {
	assert(__traits(isPOD,Node!int));
}


