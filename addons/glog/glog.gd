extends Node

# BUG: Stack traces lead back to this file instead of where the func was called.

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

const DEFAULT_CONFIG := {
	log_level = LogLevel.INFO,
	show_init_message = true,
	include_timestamp = true,
	date_separator = ".",
	include_date = true,
	include_time = true
}

const CATEGORY_NAME = "glog"


func get_glog_config_setting(key: String) -> Variant:
	# Returns null if no setting was found
	var output: Variant = null

	match key:
		"log_level":
			output = ProjectSettings.get_setting(
				"glog/config/general/log_level", DEFAULT_CONFIG.log_level
			)
		"show_init_message":
			output = ProjectSettings.get_setting(
				"glog/config/general/show_init_message", DEFAULT_CONFIG.show_init_message
			)
		"include_timestamp":
			output = ProjectSettings.get_setting(
				"glog/config/general/include_timestamp", DEFAULT_CONFIG.include_timestamp
			)
		"date_separator":
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/date_separator", DEFAULT_CONFIG.date_separator
			)
		"include_date":
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/include_date", DEFAULT_CONFIG.include_date
			)
		"include_time":
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/include_time", DEFAULT_CONFIG.include_time
			)

	return output


func _show_init_message() -> void:
	var show_init_message: int = get_glog_config_setting("show_init_message")

	if show_init_message:
		info(CATEGORY_NAME, "glog loaded successfully.")


## Returns [code]true[/code] if the log_level is enabled.
func _check_log_level(level_to_check: LogLevel) -> bool:
	var config_log_level: int = get_glog_config_setting("log_level")

	if config_log_level == LogLevel.NONE:
		return false

	if config_log_level > level_to_check:
		return false

	return true


func _get_log_level_key(level: LogLevel) -> String:
	return LogLevel.keys()[level]


func _get_date(datetime_dict: Dictionary) -> String:
	var date_separator: String = get_glog_config_setting("date_separator")

	var output = (
		"%s%s%s%s%s"
		% [
			datetime_dict.year,
			date_separator,
			"%02d" % datetime_dict.month,
			date_separator,
			"%02d" % datetime_dict.day,
		]
	)

	return output


func _get_time(datetime_dict: Dictionary) -> String:
	var output = (
		"%s:%s:%s"
		% [
			"%02d" % datetime_dict.hour,
			"%02d" % datetime_dict.minute,
			"%02d" % datetime_dict.second,
		]
	)

	return output


func _get_timestamp() -> String:
	var include_timestamp: bool = get_glog_config_setting("include_timestamp")
	var include_date: bool = get_glog_config_setting("include_date")
	var include_time: bool = get_glog_config_setting("include_time")

	if not include_timestamp:
		return ""

	var datetime_dict := Time.get_datetime_dict_from_system()

	var date := ""
	var time := ""

	if include_date:
		date = _get_date(datetime_dict)

	if include_time:
		time = _get_time(datetime_dict)

		# Add a space when both time AND date are included.
		if include_date:
			time = " " + time

	var output = "%s%s" % [date, time]
	return output


func _log_message(
	category: String,
	message: String,
	level := LogLevel.INFO,
) -> void:
	var include_timestamp: bool = get_glog_config_setting("include_timestamp")

	var timestamp = ""

	if include_timestamp:
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
			push_warning(message)

		LogLevel.ERROR:
			printerr(output)
			push_error(message)

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


func _ready() -> void:
	_show_init_message()
