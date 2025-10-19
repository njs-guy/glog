extends Node2D


func _ready() -> void:
	Glog.debug("rng", "Rolled 50")
	Glog.info("shop", "Player bought Holy Grail for 100G.")
	Glog.warn("flags", "Grandma is about to explode.")
	Glog.error("player", "Could not find PlayerController.")
