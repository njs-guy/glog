@tool
extends EditorPlugin

## Name used for the addon's autoload singleton
const AUTOLOAD_NAME = "Glog"


func _enable_plugin() -> void:
	add_autoload_singleton(
		AUTOLOAD_NAME,
		"res://addons/glog/glog.tscn",
	)


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)


func _enter_tree() -> void:
	var glog_script = load("res://addons/glog/glog.gd")
	glog_script._add_settings()
