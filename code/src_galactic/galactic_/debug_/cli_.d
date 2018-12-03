module galactic_.debug_;
import commonImports;

import galactic_.logic_world_	.world_	;

class CLI {
	import core.thread;
	import queue;
	import std.stdio;
	import std.string;
	
	this(World world) {
		this.world = world;
		ioIn = new Queue!string;
		(new Thread(&thread)).start;
		map = new Map([150,75]);
	}
	
	void update() {
		foreach (msg; ioIn) {
			import std.conv;
			map.clear;
			if (msg.length>0) switch(msg[0]) {
				case 'p':
					msg = msg[1..$].strip;
					if (msg.length==0) {
						map.pos.writeln;
						break;
					}
					char mode;
					if (msg.length>0) switch (msg[0]) {
						case '+':
						case '-':
						case '=':
							mode = msg[0];
							msg = msg[1..$].strip;
							break;
						default:
							mode = '=';
					}
					auto b = msg.countUntil!("a==','||a==' '");// break
					float[2] n;
					try {
						n = [msg[0..b].strip.to!float,msg[b+1..$].strip.to!float];
					}
					catch (Throwable e){
						"invalid".writeln;
						break;
					}
					if (mode=='+')
						n[] = map.pos[]+(n[]/map.zoom);
					if (mode=='-')
						n[] = map.pos[]-(n[]/map.zoom);
					map.pos = n;
					break;
				case 'z':
					msg = msg[1..$].strip;
					if (msg.length==0) {
						map.zoom.writeln;
						break;
					}
					char mode;
					if (msg.length>0) switch (msg[0]) {
						case '+':
						case '-':
						case '=':
							mode = msg[0];
							msg = msg[1..$].strip;
							break;
						default:
							mode = '+';
					}
					float n;
					try {
						n = msg[0..$].strip.to!float;
					}
					catch (Throwable e){
						"invalid".writeln;
						break;
					}
					if (mode=='+')
						n = map.zoom*n;
					if (mode=='-')
						n = map.zoom*(1/n);
					map.zoom = n;
					break;
				case 'w':
					map.draw(["/\\","\\/"],[0,0]);
					foreach(e; world.entities) {
						map.draw("X",e.pos);
					}
					map.show;
					break;
				default:
					break;
			}
		}
	}
	
	void thread() {
		while (true) {
			ioIn.put(readln[0..$-1]);
		}
	}
	
	World	world	;
	Queue!string	ioIn	;
	Map	map	;
}


class Map {
	import std.stdio;
	
	this(float[2] size) {
		this.size(size);
		pos = [0,0];
		zoom = 1;
	}
	
	@property {
		void size(float[2] size) {
			foreach(i;0..(size[1]).cst!size_t){
				map ~= new char[0];
				foreach(j;0..(size[0]*2).cst!size_t){
					map[$-1] ~= '-';
				}
			}
		}
		void pos(float[2] n) {
			_pos = n;
		}
		float[2] pos() {
			return _pos;
		}
		void zoom(float n) {
			_zoom = n;
		}
		float zoom() {
			return _zoom;
		}
	}
	
	char[][]	map	;
	float[2]	_pos	;
	float	_zoom	;
	
	void clear() {
		foreach(ref row; map)
			foreach(ref pix; row)
				pix = '-';
	}
	
	void draw(const(char) icon, float[2] pos) {
		if (icon!=' ') {
			pos[] -= this.pos[];
			pos[] *= zoom;
			
			pos[0] *= 2;
			pos[1] = -pos[1];
			pos[] += [map[0].length/2f, map.length/2f];
			
			size_t[] p = [pos[0].cst!size_t, pos[1].cst!size_t];
			if (p[0]>=0 && p[1]>=0 && p[0]<map[0].length && p[1]<map.length) {
				map[p[1]][p[0]] = icon;
			}
		}
	}
	void draw(const(char[]) row, float[2] pos) {
		pos[0] -= (row.length-1)/2f/2f/zoom;
		foreach(i,pix;row) {
			float[2] n;
			n[] = pos[]+[i/2f/zoom,0];
			draw(pix,n);
		}
	}
	void draw(const(char[][]) icon, float[2] pos) {
		pos[1] -= (icon.length-1)/2f/zoom;
		size_t j = 0;
		foreach_reverse(row;icon) {
			float[2] n;
			n[] = pos[]+[0,j/zoom];
			draw(row,n);
			j++;
		}
	}
	
	void show() {
		foreach(line;map) {
			line.each!write;
			writeln;
		}
	}
}