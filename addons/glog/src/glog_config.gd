class_name GlogConfig
extends Resource

# Duplicated enum because Godot crashes when this file calls LogLevel
enum LogLevel {
	## Only used for debugging. Includes traceback. Hidden by default.
	DEBUG,
	## Normal level. Same as a normal [code]print()[/code].
	INFO,
	## Warning. Prints in yellow.
	WARN,
	## Error. Same as a normal [code]printerr()[/code].
	ERROR,
	## Hides everything.
	NONE,
}

## The lowest level of output to log.
## For example, setting this to [code]Warn[/code]
## will hide all Info and Debug logs.
@export var log_level := LogLevel.INFO
## If true, shows a message at startup
## saying whether the default or custom
## config was loaded.
@export var show_init_message := true
## Whether to include the timestamp in the output.
@export var include_timestamp := true
@export_category("Timestamp settings")
## What character to use to separate the date values.
## [br] ex: [code]2025.12.25[/code]
## [br] [code]2025/12/25[/code]
## [br] [code]2025-12-25[/code]
@export_enum(".", "/", "-") var date_separator := "."
## Whether to include the date in the timestamp.
@export var include_date := true
## Whether to include the time in the timestamp.
@export var include_time := true
