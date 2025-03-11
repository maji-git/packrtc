extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("server"):
		DisplayServer.window_set_title("SERVER")
		var session = await PackRTC.host()
		await session.peer_ready
		multiplayer.multiplayer_peer = session.rtc_peer
		multiplayer.peer_connected.connect(_peer_connected)
		multiplayer.peer_disconnected.connect(_peer_disconnected)
	elif OS.has_feature("client"):
		DisplayServer.window_set_title("CLIENT")
		await get_tree().create_timer(1.0).timeout
		var session = await PackRTC.join("TEST")
		await session.peer_ready
		multiplayer.multiplayer_peer = session.rtc_peer

func _peer_connected(id):
	print(id, " connected")

func _peer_disconnected(id):
	print(id, " disconnected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
