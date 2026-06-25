class_name BossBar

extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var target: Enemy
var game_manager: GameManager

func _ready():
	game_manager = get_tree().get_first_node_in_group("game_manager")


func assign_boss_bar(enemy: Enemy):
	animation_player.play("reveal")
	texture_progress_bar.value = enemy.health_component.health
	texture_progress_bar.max_value = enemy.health_component.max_health
	enemy.health_component.damaged.connect(update_boss_bar)
	target = enemy
	update_boss_bar(0,0)


func update_boss_bar(_health, _damage):
	texture_progress_bar.value = target.health_component.health
	texture_progress_bar.max_value = target.health_component.max_health
	rich_text_label.text = "[shake level=20 rate=20]" + "TORSION"
	# animation_player.play("shakey_shakey")
	await get_tree().create_timer(0.2).timeout
	if target:
		rich_text_label.text = "[wave]" + "TORSION"
