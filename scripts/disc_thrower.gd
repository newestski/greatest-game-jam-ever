extends Enemy

@export var sight_distance: float = 200 # distance at witch enemy will start tracking you (px)
@export var approach_distance: float = 150 # distance enemy move toward you if you get to far (px)
@export var retreat_distance: float = 100 # distance enemy tries to run if you get to close (px)
@export var shoot_distance: float = 200 # distance enemy will attempt to shoot you (px)
@export var attack_cooldown: float = 3 # time between attacks (sec)

var disc_path = "res://scenes/bullets/disc.tscn" #file path of bullet

enum states{IDLE, APPROACHING, RETREATING, ATTACKING}
var state = states.IDLE
var time_since_last_attack: float = 0

func on_physics_proccess(delta: float) -> void:
	if !target: return # prevents crash if player is freed
	
	time_since_last_attack += delta
	
	if state == states.IDLE:
		if check_line_of_sight(target.global_position) and check_distance_to_point(target.position) < sight_distance:
			state = states.ATTACKING
			time_since_last_attack = 0
		
	else:
		if state == states.ATTACKING:
			velocity *= 0.9
			#conditions to change state
			if check_distance_to_point(target.position) > approach_distance or !check_line_of_sight(target.position):
				state = states.APPROACHING
			if check_distance_to_point(target.position) < retreat_distance:
				state = states.RETREATING
			
		elif state == states.APPROACHING:
			pathfind_toward_point(target.position)
			#conditions to change state
			if check_distance_to_point(target.position) < approach_distance and check_line_of_sight(target.position):
				state = states.ATTACKING
				
		elif state == states.RETREATING:
			velocity = -(target.position-position).normalized() * speed
			#conditions to change state
			if check_distance_to_point(target.position) > retreat_distance:
				state = states.ATTACKING
			if !check_line_of_sight(target.position):
				state = states.APPROACHING
		
		if check_distance_to_point(target.position) <= shoot_distance and time_since_last_attack >= attack_cooldown and check_line_of_sight(target.position):
			shoot_at_position(disc_path, target.position)
			time_since_last_attack = 0
		
		move_and_slide()
