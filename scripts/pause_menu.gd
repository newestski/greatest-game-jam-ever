extends Control

@onready var upause_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/UpauseButton
@onready var settings_button: NinePatchButton = $NinePatchRect/MarginContainer/VBoxContainer/SettingsButton
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
	
	upause_button.pressed.connect(unpause)
	settings_button.pressed.connect(open_settings)


func pause():
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


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and paused == false:
		pause()
