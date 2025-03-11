extends Node

var room_code: String = ""
var packrtc_url = "http://127.0.0.1:3000"

var http: AwaitableHTTPRequest
var server_session: PRSession
#var client_session: PKClientSession
var game_code: String
var game_channel: String = "none"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	http = AwaitableHTTPRequest.new()
	add_child(http)
	#host()

func host():
	print("Requesting Room...")
	
	var req := await http.async_request(
		packrtc_url + "/session/host",
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify({
			channel = game_channel
		})
	)
	
	var data = req.body_as_json()
	
	if data.success == false:
		print(data.code)
		return
	
	print("Creating session...")
	
	var session = PRSession.new()
	session.code = data.code
	session.ws_url = data.ws_url
	add_child(session)
	
	game_code = session.code
	server_session = session
	
	return session

func join(code: String):
	print("Joining ", code)
	
	var req := await http.async_request(
		packrtc_url + "/session/join/" + code,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify({
			channel = game_channel
		})
	)
	
	var data = req.body_as_json()
	
	if data.success == false:
		print(data.code)
		return
	
	print("Creating session...")
	
	var session = PRSession.new()
	session.code = code
	session.ws_url = data.ws_url
	add_child(session)
	
	game_code = session.code
	server_session = session
	
	return session
	
