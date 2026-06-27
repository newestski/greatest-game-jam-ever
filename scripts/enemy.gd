class_name Enemy #this is a base class that provides utility for all enemies. others should inheret

extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var speed = 50 # movement speed of enemy (pixels per second)
@export var team: String = "enemy" # the team attributed to damage created by the enemy (prevents friendly fire)
@export var reward: int = 0 #amount of money the enemy drops

var target: Node2D


#abstract classes intended to be overwritten
func on_spawn():
	pass


func on_death():
	Global.money += reward


func on_physics_proccess(_delta):
	pass


#sets things up
func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	on_spawn()
	health_component.death.connect(on_death)


func _physics_process(delta: float) -> void:
	on_physics_proccess(delta)


#UTILITY FUNCTIONS:
# sets velocity pointing toward the target_position at a magnitude of move_speed, as dictated by a NavigationAgent
func pathfind_toward_point(target_position: Vector2, move_speed: float = speed):
	navigation_agent.target_position = target_position
	var nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = nav_point_direction * move_speed


#should be self explanatory tbh
func check_distance_to_point(target_position: Vector2):
	return (position - target_position).length()


#spawns the bullet of the spesified path point toward the spesified position
func shoot_at_position(bullet_path: String, target_position: Vector2):
	#instance bullet
	var packed_bullet: PackedScene = load(bullet_path.trim_suffix(".remap"))
	var instanced_bullet: Bullet = packed_bullet.instantiate()
	if get_tree().root.has_node("/root/Root"):
		get_tree().root.get_node("/root/Root").add_child.call_deferred(instanced_bullet)
	
	#set bullets position/rotation
	instanced_bullet.damage_team = team
	instanced_bullet.global_position = global_position
	instanced_bullet.rotation = (global_position-target_position).angle()+PI/2
	return instanced_bullet


# checks the line of sight between the enemy's current position and the target position
# returns false if line of sight is blocked, and true otherwise
# USES GLOBAL COORDINATES!!!
func check_line_of_sight(target_position):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_position, 0x00000001)
	var result = space_state.intersect_ray(query)
	if result:
		return false
	else:
		return true
