extends Node


func _ready() -> void:
	pass

func host():
	var session = await PackRTC.host()
	if session is PRSession:
		await session.peer_ready
		multiplayer.multiplayer_peer = session.rtc_peer
		print("Code: ", session.code)
	else:
		print("Error: ", session)

func join(code = "TEST"):
	var session = await PackRTC.join(code)
	if session is PRSession:
		await session.peer_ready
		multiplayer.multiplayer_peer = session.rtc_peer
		print("Peer Ready!")
	else:
		print("Error: ", session)
