extends Control

@onready var play_button: NinePatchButton = $Options/VBoxContainer/PlayButton
@onready var settings_button: NinePatchButton = $Options/VBoxContainer/SettingsButton
@onready var quit_button: NinePatchButton = $Options/VBoxContainer/QuitButton
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var fade_transition: FadeTransition = $FadeTransition

var start_of_game_path = "res://scenes/root.tscn"


func _ready():
	play_button.pressed.connect(play)
	settings_button.pressed.connect(settings_menu.open)
	quit_button.pressed.connect(quit)
	
	fade_transition.animation_player.play("full_fade_in")


func play():
	fade_transition.animation_player.play("full_fade_out")
	await fade_transition.animation_player.animation_finished
	get_tree().change_scene_to_file(start_of_game_path)


func quit():
	fade_transition.animation_player.play("full_fade_out")
	await fade_transition.animation_player.animation_finished
	get_tree().quit()
