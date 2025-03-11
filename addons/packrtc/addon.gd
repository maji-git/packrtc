@tool
extends EditorPlugin


func _enter_tree() -> void:
	if not ProjectSettings.has_setting("autoload/PackRTC"):
		add_autoload_singleton("PackRTC", "res://addons/packrtc/scripts/PackRTC.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("PackRTC")
