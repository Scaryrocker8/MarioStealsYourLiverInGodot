extends Control
class_name Main

# Buttons
@export var ok_button: Button
@export var cancel_button: Button

# Sounds
@export var mario_audio: AudioStreamPlayer
@export var mario_sounds: Array[AudioStreamWAV]

func _ready() -> void:
	# Mario tells you you have 3 days until he steals your liver
	ok_button.grab_focus()
	mario_audio.stream = mario_sounds[0]
	mario_audio.play()

func _on_cancel_pressed() -> void:
	# Mario takes away option to cancel.
	cancel_button.queue_free()
	ok_button.grab_focus()
	# Mario proceeds to say that cancelling isn't an option.
	mario_audio.stream = mario_sounds[1]
	mario_audio.play()

func _on_ok_pressed() -> void:
	# Mario gives you 3 days to live.
	get_tree().quit()
