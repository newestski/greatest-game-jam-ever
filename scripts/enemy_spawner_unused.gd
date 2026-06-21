class_name EnemySpawner

extends Node2D

@onready var timer: Timer = $Timer

@export_file_path() var enemy_path: String # file path to the enemy that will be spawned

@export var max_spawn_radius = 500
@export var min_spawn_radius = 200

func _on_timer_timeout() -> void:
	spawn_enemy(enemy_path)
	timer.start()

func spawn_enemy(path):
	#instance enemy
	var packed_enemy: PackedScene = load(path)
	var instanced_enemy: Enemy = packed_enemy.instantiate()
	
	#set enemy position
	var random_rotation = randf_range(0,2*PI)
	var random_distance = randf_range(min_spawn_radius, max_spawn_radius)
	var random_position = global_position + Vector2(0,random_distance).rotated(random_rotation)
	
	get_tree().root.get_child(0).add_child(instanced_enemy)
	
	instanced_enemy.position = random_position
