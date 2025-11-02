## A simple logger for Godot 4.
extends Node

# BUG: Stack traces lead back to this file instead of where the func was called.

## The logging level.
enum LogLevel {
	## Only used for debugging. Hidden by default.
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

# TODO: Settings for include_script_filename, include_debug_traceback, and default colors

## The potential settings to be called with [method Glog._get_glog_config_setting]
enum ConfigSetting {
	LOG_LEVEL,
	SHOW_INIT_MESSAGE,
	INCLUDE_TIMESTAMP,
	DATE_SEPARATOR,
	INCLUDE_DATE,
	INCLUDE_TIME,
}

## Name used for log statements internally made by Glog.
## Does not effect logging API.
const CATEGORY_NAME = "glog"

## Default settings for Glog.
const DEFAULT_CONFIG := {
	log_level = 1,
	show_init_message = true,
	include_timestamp = true,
	date_separator = ".",
	include_date = true,
	include_time = true,
	debug_color = "#70BAFA",
	info_color = "#478CBF",
	warn_color = "#FFDE66"
}

########## LOGGING ##########


## Shows the [code]glog loaded successfully[/code] message
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


## Returns the name of the [enum LogLevel].
func _get_log_level_key(level: LogLevel) -> String:
	return LogLevel.keys()[level]


## Returns the current date as a String.
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


## Returns the current time as a String.
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


## Returns a timestamp based on current config settings as a String.
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


func _get_script_caller(include_filename := false) -> String:
	# Gets the most recent call in the current stack.
	# Basically, the filename of the script that called Glog.whatever()
	var source_filename: String = get_stack().back()["source"].get_file()

	if include_filename:
		return source_filename

	return source_filename.get_basename()


func _get_output_string(
	timestamp: String,
	log_level: LogLevel,
	category: String,
	message: String,
	print_color := false,
	color_message := false,
	color := "",
) -> String:
	var meta := "%s[%s][%s]" % [timestamp, _get_log_level_key(log_level), category]

	var output := ""

	if print_color:
		if color_message:
			# Print color, print colored message
			output = "[color=%s]%s %s" % [color, meta, message]
		else:
			# Print color, message has no color
			output = "[color=%s]%s[/color] %s" % [color, meta, message]
	else:
		# No color
		output = "%s %s" % [meta, message]

	return output


## Creates a message to be logged to output.
func _log_message(
	category: String,
	message: String,
	level := LogLevel.INFO,
) -> void:
	var include_timestamp: bool = _get_glog_config_setting(ConfigSetting.INCLUDE_TIMESTAMP)
	var include_date: bool = _get_glog_config_setting(ConfigSetting.INCLUDE_DATE)
	var include_time: bool = _get_glog_config_setting(ConfigSetting.INCLUDE_TIME)

	var timestamp := ""

	if include_timestamp:
		if include_date or include_time:
			timestamp = "[%s]" % _get_timestamp()

	var output_category := ""
	var use_filename := false

	if category == "":
		use_filename = true
		output_category = _get_script_caller()
	else:
		output_category = category

	match level:
		LogLevel.DEBUG:
			print_rich(
				_get_output_string(
					timestamp,
					level,
					output_category,
					message,
					true,
					false,
					DEFAULT_CONFIG.debug_color,
				)
			)

		LogLevel.INFO:
			print_rich(
				_get_output_string(
					timestamp,
					level,
					output_category,
					message,
					true,
					false,
					DEFAULT_CONFIG.info_color,
				)
			)

		LogLevel.WARN:
			# printwarn doesn't exist for some reason
			print_rich(
				_get_output_string(
					timestamp,
					level,
					output_category,
					message,
					true,
					true,
					DEFAULT_CONFIG.warn_color,
				)
			)

		LogLevel.ERROR:
			printerr(
				_get_output_string(
					timestamp,
					level,
					output_category,
					message,
				)
			)

		LogLevel.NONE:
			# Do nothing
			pass


########## CONFIG ##########


## Reads the project settings file using the given [enum ConfigSetting].
func _get_glog_config_setting(key: ConfigSetting) -> Variant:
	# Returns null if no setting was found
	var output: Variant = null

	match key:
		ConfigSetting.LOG_LEVEL:
			output = ProjectSettings.get_setting(
				"glog/config/general/log_level", DEFAULT_CONFIG.log_level
			)
		ConfigSetting.SHOW_INIT_MESSAGE:
			output = ProjectSettings.get_setting(
				"glog/config/general/show_init_message", DEFAULT_CONFIG.show_init_message
			)
		ConfigSetting.INCLUDE_TIMESTAMP:
			output = ProjectSettings.get_setting(
				"glog/config/general/include_timestamp", DEFAULT_CONFIG.include_timestamp
			)
		ConfigSetting.DATE_SEPARATOR:
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/date_separator", DEFAULT_CONFIG.date_separator
			)
		ConfigSetting.INCLUDE_DATE:
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/include_date", DEFAULT_CONFIG.include_date
			)
		ConfigSetting.INCLUDE_TIME:
			output = ProjectSettings.get_setting(
				"glog/config/timestamps/include_time", DEFAULT_CONFIG.include_time
			)

	return output


static func _add_bool_setting(
	name: String, default_value: bool, is_timestamp_setting := false
) -> void:
	var setting_path := ""

	if is_timestamp_setting:
		setting_path = "glog/config/timestamps/%s" % name
	else:
		setting_path = "glog/config/general/%s" % name

	if not ProjectSettings.has_setting(setting_path):
		ProjectSettings.set_setting(setting_path, default_value)

	ProjectSettings.add_property_info({"name": setting_path, "type": TYPE_BOOL})
	ProjectSettings.set_initial_value(setting_path, default_value)
	ProjectSettings.set_as_basic(setting_path, true)


static func _add_settings() -> void:
	const LOG_LEVEL_PATH := "glog/config/general/log_level"
	const DATE_SEPARATOR_PATH := "glog/config/timestamps/date_separator"

	# general

	# log_level
	if not ProjectSettings.has_setting(LOG_LEVEL_PATH):
		ProjectSettings.set_setting(LOG_LEVEL_PATH, DEFAULT_CONFIG.log_level)

	ProjectSettings.add_property_info(
		{
			"name": LOG_LEVEL_PATH,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Debug,Info,Warning,Error,None"
		}
	)
	ProjectSettings.set_initial_value(LOG_LEVEL_PATH, DEFAULT_CONFIG.log_level)
	ProjectSettings.set_as_basic(LOG_LEVEL_PATH, true)

	_add_bool_setting("show_init_message", DEFAULT_CONFIG.show_init_message)
	_add_bool_setting("include_timestamp", DEFAULT_CONFIG.include_timestamp)

	# timestamps

	# date_separator

	if not ProjectSettings.has_setting(DATE_SEPARATOR_PATH):
		ProjectSettings.set_setting(DATE_SEPARATOR_PATH, DEFAULT_CONFIG.date_separator)

	ProjectSettings.add_property_info({"name": DATE_SEPARATOR_PATH, "type": TYPE_STRING})
	ProjectSettings.set_initial_value(DATE_SEPARATOR_PATH, DEFAULT_CONFIG.date_separator)
	ProjectSettings.set_as_basic(DATE_SEPARATOR_PATH, true)

	_add_bool_setting("include_date", DEFAULT_CONFIG.include_date, true)
	_add_bool_setting("include_time", DEFAULT_CONFIG.include_time, true)


########## PUBLIC API ##########


## Logs a message containing debug information.
## [br]Debug messages are not enabled by default.
## [br]Enable this in [code]Project -> Project Settings... -> Glog/Config -> LogLevel[/code]
## [br]For proper tracebacks,
## follow this call with a [method @GlobalScope.print_debug]
## with the same message.
func debug(category: String, message: String) -> void:
	if _check_log_level(LogLevel.DEBUG):
		if OS.has_feature("debug"):
			_log_message(category, message, LogLevel.DEBUG)


## Logs a standard message to the console.
func info(category: String, message: String) -> void:
	if _check_log_level(LogLevel.INFO):
		_log_message(category, message, LogLevel.INFO)


## Logs a warning to the console.
## [br]Glog warnings are not real warnings
## and cannot be filtered though Godot's console.
## [br]For proper warning tracebacks,
## follow this call with a [method @GlobalScope.push_warning]
## with the same message.
func warn(category: String, message: String) -> void:
	if _check_log_level(LogLevel.WARN):
		_log_message(category, message, LogLevel.WARN)


## Logs an error to the console.
## [br]For proper error tracebacks,
## follow this call with a [method @GlobalScope.push_error]
## with the same message.
func error(category: String, message: String) -> void:
	if _check_log_level(LogLevel.ERROR):
		_log_message(category, message, LogLevel.ERROR)


func _ready() -> void:
	_show_init_message()
