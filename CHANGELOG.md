# Changelog

## v1.0.1 (2025/10/22)

- Removed traceback from `Glog.debug()`.

Due to how tracebacks work in Godot, this always led back to
Glog instead of where `Glog.debug()` was called.
As a result, the traceback was ALWAYS
`At: res://addons/glog/glog.gd:158:_log_message()`
which wasn't useful information.
This change is just to clean up the output.

## v1.0.0 (2025/10/22)

- Initial release
