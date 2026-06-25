class_name WinMenu

extends Control

@onready var quit_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/QuitButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: Player
var game_manager: GameManager
var fade_transition: FadeTransition
var settings_menu: SettingsMenu

var paused: bool = false #keeps track of if the pause menu is open
var pausable: bool = true #keeps track of if the game can currently be paused (not in a menu, cutscene, transition ex.)

func _ready():
	player = get_tree().get_first_node_in_group("player")
	game_manager = get_tree().get_first_node_in_group("game_manager")
	fade_transition = get_tree().get_first_node_in_group("fade_transition")
	settings_menu = get_tree().get_first_node_in_group("settings_menu")
	
	quit_button.pressed.connect(quit)


func open(delay):
	await get_tree().create_timer(delay).timeout
	fade_transition.animation_player.play("half_fade_out")
	animation_player.play("open")
	get_tree().paused = true
	$FanfareSound.play()


func quit():
	fade_transition.animation_player.play("half_to_full_fade_out")
	animation_player.play("close")
	await fade_transition.animation_player.animation_finished
	paused = false
	get_tree().paused = false
	game_manager.go_to_main_menu()
