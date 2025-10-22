@tool
extends EditorPlugin

const AUTOLOAD_NAME = "Glog"

var default_config: Dictionary = {}


func _load_default_config() -> Dictionary:
	var defaults := FileAccess.get_file_as_string("res://addons/glog/glog_config_default.json")
	return JSON.parse_string(defaults)


func _add_bool_setting(name: String, default_value: bool, is_timestamp_setting := false) -> void:
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


func _add_settings() -> void:
	const LOG_LEVEL_PATH := "glog/config/general/log_level"
	const DATE_SEPARATOR_PATH := "glog/config/timestamps/date_separator"

	# general

	# log_level
	if not ProjectSettings.has_setting(LOG_LEVEL_PATH):
		ProjectSettings.set_setting(LOG_LEVEL_PATH, default_config.log_level)

	ProjectSettings.add_property_info(
		{
			"name": LOG_LEVEL_PATH,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "Debug,Info,Warning,Error,None"
		}
	)
	ProjectSettings.set_initial_value(LOG_LEVEL_PATH, default_config.log_level)
	ProjectSettings.set_as_basic(LOG_LEVEL_PATH, true)

	_add_bool_setting("show_init_message", default_config.show_init_message)
	_add_bool_setting("include_timestamp", default_config.include_timestamp)

	# timestamps

	# date_separator

	if not ProjectSettings.has_setting(DATE_SEPARATOR_PATH):
		ProjectSettings.set_setting(DATE_SEPARATOR_PATH, default_config.date_separator)

	ProjectSettings.add_property_info({"name": DATE_SEPARATOR_PATH, "type": TYPE_STRING})
	ProjectSettings.set_initial_value(DATE_SEPARATOR_PATH, default_config.date_separator)
	ProjectSettings.set_as_basic(DATE_SEPARATOR_PATH, true)

	_add_bool_setting("include_date", default_config.include_date, true)
	_add_bool_setting("include_time", default_config.include_time, true)


func _enable_plugin() -> void:
	add_autoload_singleton(
		AUTOLOAD_NAME,
		"res://addons/glog/glog.tscn",
	)


func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)


func _enter_tree() -> void:
	default_config = _load_default_config()
	_add_settings()
