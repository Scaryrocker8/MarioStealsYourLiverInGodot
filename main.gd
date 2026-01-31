extends Control
class_name Main

const DAY: int = 86400
const DAY_TEST: int = 60

# Buttons
@export var ok_button: Button
@export var cancel_button: Button

# Sounds
@export var mario_audio: AudioStreamPlayer
@export var mario_sounds: Array[AudioStreamWAV]

var wake_time = Time.get_unix_time_from_system()# + DAY

func _ready() -> void:
	# Setup system tray
	var status_indicator: StatusIndicator = StatusIndicator.new()
	status_indicator.icon = load("res://assets/trayicon.png")
	status_indicator.tooltip = "You can't escape."
	add_child(status_indicator)
	
	var menu: PopupMenu = PopupMenu.new()
	add_child(menu)
	menu.add_item("Show Mario", 1)
	status_indicator.menu = menu.get_path()
	menu.id_pressed.connect(_on_menu_item_pressed)
	
	get_tree().set_auto_accept_quit(false)

	# Mario tells you you have 3 days until he steals your liver
	ok_button.grab_focus()
	mario_audio.stream = mario_sounds[0]
	mario_audio.play()

func _process(_delta: float) -> void:
	print(Time.get_unix_time_from_system())

func _on_menu_item_pressed(id: int) -> void:
	if id == 1:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#region Button Callbacks

func _on_cancel_pressed() -> void:
	# Mario takes away option to cancel.
	cancel_button.queue_free()
	ok_button.grab_focus()
	# Mario proceeds to say that cancelling isn't an option.
	mario_audio.stream = mario_sounds[1]
	mario_audio.play()

func _on_ok_pressed() -> void:
	# Minimize to tray
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, true)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)

#endregion
