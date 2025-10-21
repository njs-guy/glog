# Glog

A simple logger for [Godot Engine 4](https://godotengine.org/).

## Installation

### Manual
1. Download the addon files from the [releases](https://github.com/njs-guy/glog/releases).
2. Unzip the `glog.zip` file.
3. Move the `glog` folder into your project under `addons/`.
3. Enable the addon through `Project -> Project Settings... -> Plugins -> Glog`.
4. An autoload singleton will be added under the name `Glog`.

## Usage

After the addon is enabled, you can use the logger like this:

```gdscript
Glog.debug("rng", "Rolled 50")
Glog.info("shop", "Player bought Holy Grail for 100G.")
Glog.warn("flags", "Grandma is about to explode.")
Glog.error("player", "Could not find PlayerController.")
```

Which will give the following output:
```
[2025.10.21 14:51:29][DEBUG][rng] Rolled 50
   At: res://addons/glog/glog.gd:148:_log_message()
[2025.10.21 14:51:29][INFO][shop] Player bought Holy Grail for 100G.
[2025.10.21 14:51:29][WARN][flags] Grandma is about to explode.
[2025.10.21 14:51:29][ERROR][player] Could not find PlayerController.
```

The first argument is for the log category or scope, and the second is for the message itself.

That's pretty much it. Note that debug messages are disabled by default.

## Config

Go to `Project -> Project Settings...` and scroll all the way down to `Glog/Config`.

The default settings should be fine for most use cases, but you may
want to change the Log Level to Debug to output more debugging information.
How you set up what's logged is up to you.

## Writing output to file

By default, Godot automatically outputs log files.

To access them, go to `Project -> Open User Data Folder` and open the `logs` folder.

Anything output to Godot's console will be written here.

## Limitations

### Warnings are faked

Godot doesn't currently have any way to print a warning to the console through gdscript,
so all warnings sent by Glog are a yellow-colored `rich_print()`.

The warning is still labeled as a warning in the text output,
but you can't filter out the warnings like you can with the rest of the output.

This will remain an issue until Godot officially supports some kind of `printwarn()`.

### Bad tracebacks

Currently, any traceback logs will show the filepath to the Glog addon
instead of where `Glog.debug()` was called.

For this reason, it's recommended to follow any `Glog.warn()` or `Glog.error()`
with a `push_warning()` or `push_error()` with the same message
so that Godot's debugger can properly show you where the warning or error was.

If anyone knows a workaround or fix, please let me know because it's driving me crazy.


## Building

1. Clone this repo. Usually with `git clone https://github.com/njs-guy/glog.git`.
2. Open the `project.godot` file in Godot 4.5.1.
3. Run the test scene with the play button in the top right corner.
