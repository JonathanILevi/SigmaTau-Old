module ship_.galactic_.galactic_mgr_;
import commonImports;

import ship_.world_	.world_	:	World	;
import ship_.galactic_	.galactic_network_	:	GalacticNetwork	;
import ship_.world_	.entity_	:	Entity	;

import std.range;

class GalacticMgr {
	this(World world, GalacticNetwork network) {
		this.world	= world	;
		this.network	= network	;
	}
	void update() {
		{
			////import galactic_msg_.down_;
			////foreach (unknownMsg; network.map!(msgData=>UnknownMsg(msgData))) {
			////	final switch (unknownMsg.type) {
			////		case MsgType.add:
			////			auto msg = AddMsg(unknownMsg);
			////			Entity entity = new Entity(msg.pos,msg.ori);
			////			entitiesById[msg.id] = entity;
			////			world.addEntity(entity);
			////			break;
			////		case MsgType.update:
			////			auto msg = UpdateMsg(unknownMsg);
			////			Entity entity = entitiesById[msg.id];
			////			entity.pos	= msg.pos	;
			////			entity.ori	= msg.ori	;
			////			break;
			////		case MsgType.remove:
			////			auto msg = RemoveMsg(unknownMsg);
			////			world.removeEntity(entitiesById[msg.id]);
			////			entitiesById.remove(msg.id);
			////			break;
			////		case MsgType.moveAll:
			////			assert(0);
			////	}
			////}
		}
		////{
		////	import galactic_msg_.to_;
		////	auto msg = ChVelMsg();
		////	msg.vel = [1,1];
		////	msg.anv =  5;
		////	network.send(msg);
		////}
	}
	void send(const(ubyte[][]) msgs) {
		foreach (msg; msgs) {
			send(msg);
		}
	}
	void send(const(ubyte[]) msg) {
		network.send(msg);
	}
	
	private {
		World	world	;
		Entity[ushort]	entitiesById	;
		int	gameTick	;
		GalacticNetwork	network	;
	}
}

