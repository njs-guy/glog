extends Node2D

var log_path := ProjectSettings.globalize_path("user://logs/")
var message = "Wrote logs to [color=#FFDE66]%s[/color].\nPress this button to quit.\n"

@onready var message_label: RichTextLabel = %MessageLabel


func _ready() -> void:
	message_label.text = message % log_path

	Glog.debug("rng", "Rolled 50")
	Glog.info("shop", "Player bought Holy Grail for 100G.")
	Glog.warn("flags", "Grandma is about to explode.")
	Glog.error("player", "Could not find PlayerController.")


func _on_quit_button_pressed() -> void:
	# Quit the application.
	# This is only meant to display the log messages.
	get_tree().quit()
