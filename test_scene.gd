extends Node2D


func _ready() -> void:
	Glog.debug("test", "Debug message.")
	Glog.info("test", "Info message.")
	Glog.warn("test", "Warn message.")
	Glog.error("test", "Error message.")
