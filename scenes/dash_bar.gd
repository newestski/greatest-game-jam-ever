class_name DashBar

extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_dash_sound: AudioStreamPlayer = $"../DashBar/PlayerDashSound"

var player: Player
var game_manager: GameManager

func _ready():
	player = get_tree().get_first_node_in_group("player")
	game_manager = get_tree().get_first_node_in_group("game_manager")

func _process(delta: float) -> void:
	if player.dash_meter < texture_progress_bar.value:
		update_dash_bar()
	texture_progress_bar.value = player.dash_meter
	texture_progress_bar.max_value = player.max_dashes
	

func update_dash_bar():
	player_dash_sound.play()
	texture_progress_bar.max_value = player.health_component.max_health
	animation_player.play("shakey_shakey")
