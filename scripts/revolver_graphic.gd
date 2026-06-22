class_name RevolverGraphic

extends Control

@onready var bullet_1: TextureRect = $SpinnyBit/Bullet1
@onready var bullet_2: TextureRect = $SpinnyBit/Bullet2
@onready var bullet_3: TextureRect = $SpinnyBit/Bullet3
@onready var bullet_4: TextureRect = $SpinnyBit/Bullet4
@onready var bullet_5: TextureRect = $SpinnyBit/Bullet5
@onready var bullet_6: TextureRect = $SpinnyBit/Bullet6
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const EMPTY_BULLET = preload("uid://yxkhpf5oeyid")
const FULL_BULLET = preload("uid://c23wwqblt0lm8")

var player: Player
var game_manager: GameManager

var ammo: int = 6

func _ready():
	player = get_tree().get_first_node_in_group("player")
	game_manager = get_tree().get_first_node_in_group("game_manager")
	update_ammo_display()


func update_ammo_display():
	ammo = player.ammunition
	var bullet_list: Array[TextureRect] = [bullet_1, bullet_2, bullet_3, bullet_4, bullet_5, bullet_6]
	for i in range(0,6):
		if i >= ammo:
			bullet_list[i].texture = EMPTY_BULLET
		else:
			bullet_list[i].texture = FULL_BULLET


func spend_bullet():
	animation_player.speed_scale = 2/player.firerate
	bullet_1.texture = EMPTY_BULLET
	animation_player.play("spend_bullet")
	await animation_player.animation_finished
	update_ammo_display()



func reload_bullet():
	bullet_6.texture = FULL_BULLET
	animation_player.speed_scale = 2/player.reload_speed
	animation_player.play("reload_bullet")
	await animation_player.animation_finished
	update_ammo_display()
