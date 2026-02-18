extends Control
class_name Main

const DAY: int = 86400

@export_group("Buttons")
@export var ok_button: Button
@export var cancel_button: Button
@export_group("Sounds")
@export var mario_audio: AudioStreamPlayer
@export var mario_sounds: Array[AudioStreamWAV]
@export_group("Label")
@export var title_label: Label

var wake_time0: int = Time.get_unix_time_from_system() as int + DAY
var wake_time1: int = Time.get_unix_time_from_system() as int + DAY * 2
var wake_time2: int = Time.get_unix_time_from_system() as int + DAY * 3

func _ready() -> void:
	# Setup system tray
	var status_indicator: StatusIndicator = StatusIndicator.new()
	status_indicator.icon = load("res://assets/trayicon.png")
	status_indicator.tooltip = "You can't escape."
	add_child(status_indicator)
	
	var menu: PopupMenu = PopupMenu.new()
	add_child(menu)
	menu.add_item("You can't escape.", 1)
	status_indicator.menu = menu.get_path()
	menu.id_pressed.connect(_on_menu_item_pressed)
	
	# Don't allow user to quit application
	get_tree().set_auto_accept_quit(false)

	# Mario tells you you have 3 days until he steals your liver
	ok_button.grab_focus()
	mario_audio.stream = mario_sounds[0]
	mario_audio.play()

func _process(_delta: float) -> void:

	# 2 Days
	if Time.get_unix_time_from_system() as int == wake_time0:
		_window()
		mario_audio.stream = mario_sounds[2]
		mario_audio.play()
		title_label.text = "2 days until Mario steals your liver"
	# 1 Day
	elif Time.get_unix_time_from_system() as int == wake_time1:
		_window()
		mario_audio.stream = mario_sounds[3]
		mario_audio.play()
		title_label.text = "1 day until Mario steals your liver"
	# ...
	elif Time.get_unix_time_from_system() as int == wake_time2:
		_window()
		mario_audio.stream = mario_sounds[4]
		mario_audio.play()
		title_label.text = ""
		await mario_audio.finished
		get_tree().quit()

func _window() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, false)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _minimize() -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, true)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)

func _on_menu_item_pressed(id: int) -> void:
	if id == 1:
		_window()

#region Button Callbacks

func _on_cancel_pressed() -> void:
	# Mario takes away option to cancel.
	cancel_button.queue_free()
	ok_button.grab_focus()
	# Mario proceeds to say that cancelling isn't an option.
	mario_audio.stream = mario_sounds[1]
	mario_audio.play()

func _on_ok_pressed() -> void:
	# Minimize to tray.
	_minimize()

#endregion
