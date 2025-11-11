# Glog

A simple GDScript logger for [Godot Engine 4](https://godotengine.org/).

## Installation

### Manual

1. Download the addon files from the [releases](https://github.com/njs-guy/glog/releases).
2. Unzip the `glog.zip` file.
3. Move the `glog` folder into your project under `addons/`.
3. Enable the addon through `Project -> Project Settings... -> Plugins -> Glog`.
4. Under `Project Settings -> Globals`, move `Glog` to the top of the list.
5. An autoload singleton will be added under the name `Glog`.

### Minimum Godot version

TL;DR `Godot 4.1.4`

Glog should work with Godot 4.1.4 or newer out of the box,
but in older versions, you may get a warning about an invalid UID.
This warning can be safely ignored
as long as the addon is working as expected.

Glog will work on 4.0.4 if you disable a few lines in `addons/glog/glog.gd`
that set the config settings as a basic setting.
After that, you'll need to enable advanced settings to change the config.

So while you *can* use Glog in Godot 4.0.4, it's not recommended.

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
[2025.10.21 14:51:29][INFO][shop] Player bought Holy Grail for 100G.
[2025.10.21 14:51:29][WARN][flags] Grandma is about to explode.
[2025.10.21 14:51:29][ERROR][player] Could not find PlayerController.
```

The first argument is for the log category or scope, and the second is for the message itself.

The tags at the beginning of the message will be colored in the Godot output panel.
Their colors can be changed in the project settings, or on a per-message basis like this.
```gdscript
Glog.info("player_state", "The player died.", "#ef4444")
```
This argument accepts any [Color](https://docs.godotengine.org/en/stable/classes/class_color.html)
that Godot accepts.

C# support is limited, clunky and error prone. While it does work for the most part,
Glog was made with GDScript in mind.
It can be accessed like any other GDScript singleton. For example:
```cs
// C#

var glog = GetNode<Node>("/root/Glog");

glog.Call("debug", "rng", "Rolled 50");
glog.Call("info", "shop", "Player bought Holy Grail for 100G.", "#ef4444");
glog.Call("warn", "flags", "Grandma is about to explode.");
glog.Call("error", "player", "Could not find PlayerController.");
```

That's pretty much it.

## Config

Go to `Project -> Project Settings...` and scroll all the way down to `Glog/Config`.

The default settings should be fine for most use cases.
What information you decide to log is up to you.

### General

- Log Level: The lowest logging level to write to output. Defaults to Debug.
Debug messages are hidden in release builds.
- Show Init Message: Whether to show the `glog loaded successfully` message at startup.
Defaults to true.
- Include Debug Traceback - Whether to show function traceback for debug messages. Defaults to true.
- Include Timestamp: Whether to print a timestamp for each log. Defaults to true.

### Timestamps

- Date Separator: What character to use to separate date numbers. Defaults to ".".
- Include Date: Whether to include a date in the timestamp. Defaults to true.
- Include Time: Whether to include the time in the timestamp. Defaults to true.

### Colors

- Show Colors: Which messages should display colors. Defaults to All.
- Debug Color: The color  for debug messages. Defaults to #70BAFA.
- Info Color: The color  for info messages. Defaults to #478CBF.
- Warning Color: The color  for warning messages. Defaults to #FFDE66.

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

### Limited C# support

Glog was written for GDScript. While you can still call the singleton from C#,
it's messy and error-prone. Debug traceback is also broken in C# and traces back to `glog.gd` because of language differences.

If your codebase has a lot of C#, Glog may not be for you.


## Building

1. Clone this repo. Usually with `git clone https://github.com/njs-guy/glog.git`.
2. Open [Godot 4.5.1](https://godotengine.org/download/archive/4.5.1-stable/)
and select `Import` in the top left corner.
3. Select the `project.godot` from the root folder and click `Open`.
4. Run the test scene with the play button in the top right corner.

## License

All code in this repo, unless otherwise stated, is licensed under the [MIT License](LICENSE.txt).

All assets in the assets folder, unless otherwise stated, are licensed under the [CC0-1.0 License](./assets/LICENSE.txt).
