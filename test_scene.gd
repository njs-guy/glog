extends Node2D


func _ready() -> void:
	Glog.debug("DEBUG", "Debug message.")
	Glog.info("INFO", "Info message.")
	Glog.warn("WARN", "Warn message.")
	Glog.error("ERROR", "Error message.")
