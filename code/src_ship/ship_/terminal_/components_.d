module ship_.terminal_.components_;
import commonImports;

import std.range;

static import terminal_msg_.up_;

import ship_.world_	.world_	;
import ship_.world_	.entity_	;
import ship_.terminal_	.terminal_network_	:	TerminalNetwork	;

public import terminal_msg_	.component_type_	:	ComponentType	;

abstract class Component {
	this(ubyte id, World world, Component[] delegate(ComponentType) getComponent) {
		this.id	= id	;
		this.world	= world	;
		this.getComponent	= getComponent	;
	}
	abstract @property ComponentType type();
	ComponentType opCast(T:ComponentType)() {
		return type;
	}
	abstract void update();
	abstract void onMsg(terminal_msg_.up_.UnknownMsg, TerminalNetwork from);
	private {
		ubyte	id	;
		World	world	;
		Component[] delegate(ComponentType)	getComponent	;
	}
}

class MetaRadar : Component {
	import terminal_msg_.meta_radar;
	this(ubyte id, World world, Component[] delegate(ComponentType) getComponent) {
		super(id, world, getComponent);
	}
	override @property ComponentType type() {
		return ComponentType.metaRadar;
	}
	override void update() {
		/*	// This comment is mostly copied from the galactic `galactic_.network_.ship_`.
			Here we send msgs to the terminal to update its world.
			This does not get updated when entities get added or removed.
				I chose not to have msgs sent because it was causing to much
				spider webed communication.  The world logic needs to be able
				to work without thinking about networking.
			The world.entities garantees that entities added will be added to
				the end, thus garanteeing that world.entities will not get reordered.
				Entities also have a `inWorld` property that gets set to false when
				it is removed.
			We keep an array of what the ship client sees (and the ids attached
				each entity).  (`syncedEntities` and `entityIds`)
			This allows a great algorithm which avoids exesive recursions of
				either array.  We can loop through our array updating the client
				while checking if the entity is remove.  We then know that the
				entities we have are in world.entities and we also know they are
				in the same order and at the beginning.  Thus, any entity in
				`world.entities` after our last entity is a new entity.
		*/
		////import terminal_msg_.down_meta_radar_;
		//---Update entities synced with cliend (update/remove)
		foreach_reverse (i, entity; syncedEntities) {
			if (!entity.getInWorld) {
				//---Send Remove Msg to client
				{
					entities.remove(entityIds[i]);
				}
				//---Remove reference
				{
					syncedEntities	= syncedEntities	.remove(i);
					entityIds	= entityIds	.remove(i);
				}
			}
			else {
				//---Send Update Msg to client
				entities.change(	entityIds[i]	,
					entity.pos	,
					entity.ori	,);
			}
		}
		//---Add new entities
		Entity[] newEntities =	syncedEntities.length>0
			? world.entities.find(syncedEntities[$-1])[1..$]
			: world.entities;
		syncedEntities.reserve(syncedEntities.length+newEntities.length);
		foreach (i,entity; newEntities) {
			syncedEntities	~=entity	;
			entityIds	~=entities.add(	entity.pos	,
					entity.ori	,);
		}
		
		////streamers	~= newStreamers;
		////readers	= [];
		////newStreamers	= [];
	}
	override void onMsg(terminal_msg_.up_.UnknownMsg unknownMsg, TerminalNetwork from) {
		////import terminal_msg_.up_meta_radar_;
		////final switch (unknownMsg.type) {
		////	case MsgType.read:
		////		log("metaRadar msg read:");
		////		////auto msg = ReadMsg(unknownMsg);
		////		readers ~= from;
		////		break;
		////	case MsgType.stream:
		////		log("metaRadar msg stream:");
		////		////auto msg = StreamMsg(unknownMsg);
		////		newStreamers ~= from;
		////		break;
		////}
	}
	
	private {
		////TerminalNetwork[] readers	= []	;
		////TerminalNetwork[] streamers	= []	;
		////TerminalNetwork[] newStreamers	= []	; // Will be added to streamers once it gets updated.
		
		Entities	entities	;
		
		ushort[]	entityIds	= []	;
		Entity[]	syncedEntities	= []	;
		////ushort	nextId	= 0	;
	}
}


private {
	void sendAll(TerminalNetwork[] to, const(ubyte)[] msg) {
		sendAll([to], msg);
	}
	void sendAll(TerminalNetwork[][] to, const(ubyte)[] msg) {
		foreach (group; to) foreach (network; group) {
			network.send(msg);
		}
	}
}


class MetaMove : Component {
	this(ubyte id, World world, Component[] delegate(ComponentType) getComponent) {
		super(id, world, getComponent);
	}
	override @property ComponentType type() {
		return ComponentType.metaMove;
	}
	override void update() {
		////foreach (reader; forwardReaders) {
		////	sendForwardRead(reader);
		////}
		////foreach (reader; strafeReaders) {
		////	sendStrafeRead(reader);
		////}
		////forwardReaders = [];
		////strafeReaders = [];
		////foreach (streamer; forwardStreamers) {
		////	sendForwardRead(streamer);
		////}
		////foreach (streamer; strafeStreamers) {
		////	sendStrafeRead(streamer);
		////}
	}
	override void onMsg(terminal_msg_.up_.UnknownMsg unknownMsg, TerminalNetwork from) {
		////import terminal_msg_.up_meta_move_;
		////final switch (unknownMsg.type) {
		////	case MsgType.read:
		////		log("metaRadar msg read:");
		////		auto msg = ReadMsg(unknownMsg);
		////		if (msg.axis == Axis.forward) {
		////			forwardReaders ~= from;
		////		}
		////		else if (msg.axis == Axis.strafe) {
		////			strafeReaders ~= from;
		////		}
		////		break;
		////	case MsgType.stream:
		////		log("metaRadar msg stream:");
		////		auto msg = StreamMsg(unknownMsg);
		////		if (msg.axis == Axis.forward) {
		////			forwardStreamers ~= from;
		////		}
		////		else if (msg.axis == Axis.strafe) {
		////			strafeStreamers ~= from;
		////		}
		////		break;
		////	case MsgType.set:
		////		log("metaRadar msg stream:");
		////		auto msg = SetMsg(unknownMsg);
		////		msg.value.log;
		////		break;
		////}
	}
	
	private {
		////TerminalNetwork[] forwardReaders	= []	;
		////TerminalNetwork[] forwardStreamers	= []	;
		////TerminalNetwork[] strafeReaders	= []	;
		////TerminalNetwork[] strafeStreamers	= []	;
		////
		////void sendForwardRead(TerminalNetwork to) {
		////	import terminal_msg_.down_meta_move_;
		////	auto msg = UpdateMsg(this.id);
		////	msg.axis	= Axis.forward	;
		////	msg.value	= 0	;
		////	to.send(msg);
		////}
		////void sendStrafeRead(TerminalNetwork to) {
		////	import terminal_msg_.down_meta_move_;
		////	auto msg = UpdateMsg(this.id);
		////	msg.axis	= Axis.strafe	;
		////	msg.value	= 0	;
		////	to.send(msg);
		////}
	}
}
































