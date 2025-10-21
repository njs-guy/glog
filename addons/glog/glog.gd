## A simple logger for Godot 4.
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

## The potential settings to be called with [method Glog._get_glog_config_setting]
enum ConfigSetting {
	LOG_LEVEL,
	SHOW_INIT_MESSAGE,
	INCLUDE_TIMESTAMP,
	DATE_SEPARATOR,
	INCLUDE_DATE,
	INCLUDE_TIME,
}

const CATEGORY_NAME = "glog"

var default_config: Dictionary = {}


func _load_default_config() -> Dictionary:
	var defaults := FileAccess.get_file_as_string("res://addons/glog/glog_config_default.json")
	return JSON.parse_string(defaults)


func _show_init_message() -> void:
	var show_init_message: int = _get_glog_config_setting(ConfigSetting.SHOW_INIT_MESSAGE)

	if show_init_message:
		info(CATEGORY_NAME, "glog loaded successfully.")


## Returns [code]true[/code] if the log_level is enabled.
func _check_log_level(level_to_check: LogLevel) -> bool:
	var config_log_level: int = _get_glog_config_setting(ConfigSetting.LOG_LEVEL)

	if config_log_level == LogLevel.NONE:
		return false

	if config_log_level > level_to_check:
		return false

	return true


func _get_log_level_key(level: LogLevel) -> String:
	return LogLevel.keys()[level]


func _get_date(datetime_dict: Dictionary) -> String:
	var date_separator: String = _get_glog_config_setting(ConfigSetting.DATE_SEPARATOR)

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
	var include_timestamp: bool = _get_glog_config_setting(ConfigSetting.INCLUDE_TIMESTAMP)
	var include_date: bool = _get_glog_config_setting(ConfigSetting.INCLUDE_DATE)
	var include_time: bool = _get_glog_config_setting(ConfigSetting.INCLUDE_TIME)

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
	var include_timestamp: bool = _get_glog_config_setting(ConfigSetting.INCLUDE_TIMESTAMP)

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


func _get_glog_config_setting(key: ConfigSetting) -> Variant:
	# Returns null if no setting was found
	var output: Variant = null

	match key:
		ConfigSetting.LOG_LEVEL:
			output = ProjectSettings.get_setting(
				"glog/config/general/log_level", default_config.log_level
			)
		ConfigSetting.SHOW_INIT_MESSAGE:
			output = ProjectSettings.get_setting(
				"glog/config/general/show_init_message", default_config.show_init_message
			)
		ConfigSetting.INCLUDE_TIMESTAMP:
			output = ProjectSettings.get_setting(
				"glog/config/general/include_timestamp", default_config.include_timestamp
			)
		ConfigSetting.DATE_SEPARATOR:
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/date_separator", default_config.date_separator
			)
		ConfigSetting.INCLUDE_DATE:
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/include_date", default_config.include_date
			)
		ConfigSetting.INCLUDE_TIME:
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/include_time", default_config.include_time
			)

	return output


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
	default_config = _load_default_config()
	_show_init_message()
