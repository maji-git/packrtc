extends Node

## PackRTC Signaler URL, change this if you want to use your own instance.
var packrtc_url = "https://packcloud.himaji.xyz"

var _http: AwaitableHTTPRequest
## Get the current session
var session: PRSession
## Game code for this session
var game_code: String
## Channel for your game, this code is unique to your game. Set it before hosting/joining
var game_channel: String = "none"
## Determine if debug mode is enabled, if it's. The room code will always be "TEST"
var enable_debug: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_http = AwaitableHTTPRequest.new()
	add_child(_http)
	#host()

func host():
	var dbug = false
	
	if enable_debug and OS.has_feature("editor"):
		dbug = true
	
	var req := await _http.async_request(
		packrtc_url.trim_suffix("/") + "/session/host",
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify({
			channel = game_channel,
			is_debug = dbug
		})
	)
	
	var data = req.body_as_json()
	
	if data.success == false:
		return data.code
	
	var s = PRSession.new()
	s.code = data.code
	s.ws_url = data.ws_url
	add_child(s)
	
	game_code = s.code
	session = s
	
	return session

func join(code: String):
	print("Joining ", code)
	
	var req := await _http.async_request(
		packrtc_url.trim_suffix("/") + "/session/join/" + code,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		JSON.stringify({
			channel = game_channel
		})
	)
	
	var data = req.body_as_json()
	
	if data.success == false:
		return data.code
	
	var s = PRSession.new()
	s.code = code
	s.ws_url = data.ws_url
	add_child(s)
	
	game_code = s.code
	session = s
	
	return session
	
