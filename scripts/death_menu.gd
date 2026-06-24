class_name DeathMenu

extends Control

@onready var retry_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/RetryButton
@onready var quit_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/QuitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var floor_label: Label = $NinePatchRect/MarginContainer/VBoxContainer/FloorLabel

var player: Player
var game_manager: GameManager
var fade_transition: FadeTransition
var settings_menu: SettingsMenu
var pause_menu: PauseMenu

func _ready():
	player = get_tree().get_first_node_in_group("player")
	game_manager = get_tree().get_first_node_in_group("game_manager")
	fade_transition = get_tree().get_first_node_in_group("fade_transition")
	settings_menu = get_tree().get_first_node_in_group("settings_menu")
	pause_menu = get_tree().get_first_node_in_group("pause_menu")
	
	player.health_component.death.connect(open)
	retry_button.pressed.connect(retry)
	quit_button.pressed.connect(quit)


func open():
	fade_transition.animation_player.play("half_fade_out")
	animation_player.play("open")
	floor_label.text = "Score: Floor "+str(game_manager.current_floor)
	pause_menu.pausable = false


func retry():
	fade_transition.animation_player.play("half_to_full_fade_out")
	animation_player.play("close")
	await fade_transition.animation_player.animation_finished
	get_tree().reload_current_scene()


func quit():
	fade_transition.animation_player.play("half_to_full_fade_out")
	animation_player.play("close")
	await fade_transition.animation_player.animation_finished
	game_manager.go_to_main_menu()
