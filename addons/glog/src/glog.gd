extends Node

# TODO: output to file
# TODO: timestamp
# TODO: config file

enum LogLevel {
	DEBUG,
	INFO,
	WARN,
	ERROR,
	NONE,
}

@export var log_level := LogLevel.INFO
@export var include_timestamp := true
# @export var output_to_file := false


## Returns [code]true[/code] if the log_level is enabled.
func _check_log_level(level_to_check: LogLevel) -> bool:
	if log_level == LogLevel.NONE:
		return false

	if log_level > level_to_check:
		return false

	return true


func _get_timestamp() -> String:
	if !include_timestamp:
		return ""

	var datetime_dict := Time.get_datetime_dict_from_system()
	var output = (
		"%s/%s/%s %s:%s:%s"
		% [
			datetime_dict.year,
			datetime_dict.month,
			datetime_dict.day,
			datetime_dict.hour,
			datetime_dict.minute,
			datetime_dict.second,
		]
	)
	return output


func _log_message(
	category: String,
	message: String,
	level := LogLevel.INFO,
) -> void:
	var timestamp = ""

	if include_timestamp:
		timestamp = "[%s]" % _get_timestamp()

	var output := (
		"%s[%s] %s"
		% [
			timestamp,
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
			print_rich("[color=#FFDE66][b]WARNING:[/b] %s" % output)

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
