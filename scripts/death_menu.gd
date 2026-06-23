class_name DeathMenu

extends Control

@onready var retry_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/RetryButton
@onready var quit_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/QuitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: Player
var game_manager: GameManager
var fade_transition: FadeTransition
var settings_menu: SettingsMenu

var paused: bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	game_manager = get_tree().get_first_node_in_group("game_manager")
	fade_transition = get_tree().get_first_node_in_group("fade_transition")
	settings_menu = get_tree().get_first_node_in_group("settings_menu")
	
	player.health_component.death.connect(open)
	retry_button.pressed.connect(retry)
	quit_button.pressed.connect(quit)


func open():
	fade_transition.animation_player.play("half_fade_out")
	animation_player.play("open")


func retry():
	get_tree().reload_current_scene()


func quit():
	pass
