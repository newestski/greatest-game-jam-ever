extends Enemy

@export var sight_distance = 250 # distance at witch enemy will start moveing toward you (px)
@export var hit_distance = 50 # distance at witch enemy will attempt to hit you (px)
@export var attack_cooldown = 0.5 # time between attacks (sec)

var spinny_orb_melee_path = "res://scenes/bullets/spinny_orb_melee.tscn" #file path of bullet

enum states{IDLE, ATTACKING}
var state = states.IDLE
var time_since_last_attack: float = 0

func _physics_process(delta: float) -> void:
	
	time_since_last_attack += delta
	
	if state == states.IDLE:
		if check_line_of_sight(target.global_position) and check_distance_to_point(target.global_position) < sight_distance:
			state = states.ATTACKING
	elif state == states.ATTACKING:
		pathfind_toward_point(target.global_position)
		if check_distance_to_point(target.global_position) <= hit_distance and time_since_last_attack >= attack_cooldown:
			shoot_at_position(spinny_orb_melee_path, target.global_position)
			time_since_last_attack = 0
	
	move_and_slide()
