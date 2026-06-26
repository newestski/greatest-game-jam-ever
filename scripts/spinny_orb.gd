extends Enemy

@onready var spinny_sprite: Sprite2D = $SpinnySprite
@onready var orb_sprite: AnimatedSprite2D = $OrbSprite

@export var sight_distance = 250 # distance at witch enemy will start moveing toward you (px)
@export var hit_distance = 50 # distance at witch enemy will attempt to hit you (px)
@export var attack_cooldown = 0.5 # time between attacks (sec)
@export var spin_speed_normal = 90 
@export var spin_speed_attack = 180 

var spinny_orb_melee_path = "res://scenes/bullets/spinny_orb_melee.tscn" #file path of bullet

enum states{IDLE, ATTACKING}
var state = states.IDLE
var time_since_last_attack: float = 0

func on_spawn() -> void:
	orb_sprite.play("default")


func on_physics_proccess(delta: float) -> void:
	if !target: return # prevents crash if player is freed
	time_since_last_attack += delta
	print(state)
	if state == states.IDLE:
		if check_line_of_sight(target.global_position) and check_distance_to_point(target.global_position) < sight_distance:
			state = states.ATTACKING
	elif state == states.ATTACKING:
		pathfind_toward_point(target.global_position)
		if check_distance_to_point(target.global_position) <= hit_distance and time_since_last_attack >= attack_cooldown:
			shoot_at_position(spinny_orb_melee_path, target.global_position)
			time_since_last_attack = 0
		if check_distance_to_point(target.global_position) <= hit_distance:
			spinny_sprite.rotation_degrees += spin_speed_attack * delta
		else:
			spinny_sprite.rotation_degrees += spin_speed_normal * delta
	move_and_slide()
