class_name SettingsMenu

extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var back_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/BackButton
@onready var sounds_slider: HSlider = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer2/SoundsSlider
@onready var music_slider: HSlider = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer3/MusicSlider
@onready var full_screen_toggle: CheckButton = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer4/FullScreenToggle

var master_bus_index
var music_bus_index
var sfx_bus_index

func _ready():
	master_bus_index = AudioServer.get_bus_index("Master")
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("Sounds")
	
	sounds_slider.value = AudioServer.get_bus_volume_linear(sfx_bus_index)
	music_slider.value = AudioServer.get_bus_volume_linear(music_bus_index)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		full_screen_toggle.button_pressed = true


func open():
	animation_player.play("open")


func close():
	animation_player.play("close")


func _on_sounds_slider_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(sfx_bus_index, volume_db)


func _on_music_slider_value_changed(value: float) -> void:
	var volume_db = linear_to_db(value)
	AudioServer.set_bus_volume_db(music_bus_index, volume_db)


func _on_back_button_pressed() -> void:
	close()


func _on_full_screen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
