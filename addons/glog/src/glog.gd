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
# @export var output_to_file := false
# @export var include_timestamp := false


## Returns [code]true[/code] if the log_level is enabled.
func _check_log_level(level_to_check: LogLevel) -> bool:
	if log_level == LogLevel.NONE:
		return false

	if log_level > level_to_check:
		return false

	return true


func log_message(
	category: String,
	message: String,
	level := LogLevel.INFO,
	separator := " ",
) -> void:
	var output := "%s%s%s" % [category, separator, message]

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


func debug(category: String, message: String, separator := " ") -> void:
	if _check_log_level(LogLevel.DEBUG):
		log_message(category, message, LogLevel.DEBUG, separator)


func info(category: String, message: String, separator := " ") -> void:
	if _check_log_level(LogLevel.INFO):
		log_message(category, message, LogLevel.INFO, separator)


func warn(category: String, message: String, separator := " ") -> void:
	if _check_log_level(LogLevel.WARN):
		log_message(category, message, LogLevel.WARN, separator)


func error(category: String, message: String, separator := " ") -> void:
	if _check_log_level(LogLevel.ERROR):
		log_message(category, message, LogLevel.ERROR, separator)
