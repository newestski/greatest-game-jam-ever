class_name PauseMenu

extends Control

@onready var upause_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/UpauseButton
@onready var settings_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/SettingsButton
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
	
	upause_button.pressed.connect(unpause)
	settings_button.pressed.connect(open_settings)
	quit_button.pressed.connect(quit)


func pause():
	if pausable:
		paused = true
		fade_transition.animation_player.play("half_fade_out")
		get_tree().paused = true
		animation_player.play("open")


func unpause():
	fade_transition.animation_player.play("half_fade_in")
	paused = false
	get_tree().paused = false
	animation_player.play("close")


func open_settings():
	settings_menu.open()


func quit():
	fade_transition.animation_player.play("half_to_full_fade_out")
	animation_player.play("close")
	await fade_transition.animation_player.animation_finished
	paused = false
	get_tree().paused = false
	game_manager.go_to_main_menu()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and paused == false:
		pause()
