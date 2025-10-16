extends Node

# TODO: output to file

## The logging level.
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

var config := preload("uid://c6u2ab2cl8qk7")

# TODO: _try_load_config()


## Returns [code]true[/code] if the log_level is enabled.
func _check_log_level(level_to_check: LogLevel) -> bool:
	if config.log_level == LogLevel.NONE:
		return false

	if config.log_level > level_to_check:
		return false

	return true


func _get_log_level_key(level: LogLevel) -> String:
	return LogLevel.keys()[level]


func _get_timestamp() -> String:
	if !config.include_timestamp:
		return ""

	var datetime_dict := Time.get_datetime_dict_from_system()
	var output = (
		"%s.%s.%s %s:%s:%s"
		% [
			datetime_dict.year,
			"%02d" % datetime_dict.month,
			"%02d" % datetime_dict.day,
			"%02d" % datetime_dict.hour,
			"%02d" % datetime_dict.minute,
			"%02d" % datetime_dict.second,
		]
	)
	return output


func _log_message(
	category: String,
	message: String,
	level := LogLevel.INFO,
) -> void:
	var timestamp = ""

	if config.include_timestamp:
		timestamp = "[%s]" % _get_timestamp()

	var output := (
		"%s[%s][%s] %s"
		% [
			timestamp,
			_get_log_level_key(level),
			category,
			message,
		]
	)

	match level:
		LogLevel.DEBUG:
			print_debug(output)

		LogLevel.INFO:
			print(output)

		LogLevel.WARN:
			# print_warn doesn't exist for some reason
			print_rich("[color=#FFDE66]%s" % output)

		LogLevel.ERROR:
			printerr(output)

		LogLevel.NONE:
			# Do nothing
			pass


func debug(category: String, message: String) -> void:
	if _check_log_level(LogLevel.DEBUG):
		_log_message(category, message, LogLevel.DEBUG)


func info(category: String, message: String) -> void:
	if _check_log_level(LogLevel.INFO):
		_log_message(category, message, LogLevel.INFO)


func warn(category: String, message: String) -> void:
	if _check_log_level(LogLevel.WARN):
		_log_message(category, message, LogLevel.WARN)


func error(category: String, message: String) -> void:
	if _check_log_level(LogLevel.ERROR):
		_log_message(category, message, LogLevel.ERROR)

# func _ready() -> void:
# 	config = preload("res://addons/glog/src/default_glog_config.tres")
