extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var sight_distance: float = 200 # distance at witch enemy will start tracking you (px)
@export var acceleration: float = 1 # rate at witch enemy accelrates upon seeing you (px/s^2)
@export var friction: float = 0.98 # factor controling speed of decceleration (1 = no friction, 0 = instant stop)
@export var attack_cooldown: float = 0.1 # time between attacks (sec)
@export var spin_acceleration: float = 10

var spinning_rammer_melee_path = "res://scenes/bullets/spinning_rammer_melee.tscn" #file path of bullet

enum states{IDLE, ATTACKING}

var state = states.IDLE
var time_since_last_attack: float = 0
var spin_speed: float = 0
func on_physics_proccess(delta: float) -> void:
	if !target: return # prevents crash if player is freed
	
	time_since_last_attack += delta
	
	if state == states.IDLE:
		animated_sprite_2d.play("idle")
		velocity *= friction
		
		if check_line_of_sight(target.global_position) and check_distance_to_point(target.position) < sight_distance:
			state = states.ATTACKING
	elif state == states.ATTACKING:
		spin_speed += spin_acceleration * delta
		animated_sprite_2d.play("default")
		velocity += (target.position - position) * delta * acceleration
		if !check_line_of_sight(target.global_position) or check_distance_to_point(target.position) > sight_distance:
			state = states.IDLE
		if time_since_last_attack >= attack_cooldown:
			shoot_at_position(spinning_rammer_melee_path, target.position)
			time_since_last_attack = 0
	animated_sprite_2d.rotation_degrees += spin_speed
	spin_speed *= friction
	move_and_slide()
