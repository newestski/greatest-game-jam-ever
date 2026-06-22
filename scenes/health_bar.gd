class_name HealthBar

extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player: Player
var game_manager: GameManager

func _ready():
	player = get_tree().get_first_node_in_group("player")
	game_manager = get_tree().get_first_node_in_group("game_manager")
	player.health_component.damaged.connect(update_health_bar)
	update_health_bar(0, 0)

func update_health_bar(_health, _damage):
	texture_progress_bar.value = player.health_component.health
	texture_progress_bar.max_value = player.health_component.max_health
	rich_text_label.text = "[shake level=20 rate=20]" + str(ceili(player.health_component.health))+"/"+str(ceili(player.health_component.max_health))
	animation_player.play("shakey_shakey")
	await get_tree().create_timer(0.2).timeout
	rich_text_label.text = "[wave]" + str(ceili(player.health_component.health))+"/"+str(ceili(player.health_component.max_health))
