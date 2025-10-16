class_name GlogConfig
extends Resource

# Duplicated enum because Godot crashes when this file calls LogLevel
enum Levels {
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
@export var log_level := Levels.INFO
@export_category("Timestamps")
## Whether to include the timestamp in the output.
@export var include_timestamp := true
## Whether to include the year in the timestamp.
@export var include_year := true
## Whether to include the month in the timestamp.
@export var include_month := true
## Whether to include the day in the timestamp.
@export var include_day := true
## Whether to include the hour in the timestamp.
@export var include_hour := true
## Whether to include the minute in the timestamp.
@export var include_minute := true
## Whether to include the seconds in the timestamp.
@export var include_seconds := true
