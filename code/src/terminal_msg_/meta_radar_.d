module terminal_msg_.meta_radar_;
import commonImports;


struct Entities {
	private {
		ushort nextId = 0;
	}
	public {
		ushort add(float[2] pos, float ori) {
			// Send add to terminals
			return nextId++;
		}
		void remove(ushort id, Entity entity) {
			// Send remove to terminals
		}
		void change(ushort id, float[2] pos, float ori) {
			// Send change to terminals
		}
	}
}


