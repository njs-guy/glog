extends Node2D


func _ready() -> void:
	Glog.debug("rng", "Debug message.")
	Glog.info("shop", "Info message.")
	Glog.warn("flags", "Warn message.")
	Glog.error("player", "Error message.")
