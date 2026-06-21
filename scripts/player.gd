class_name Player

extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent

@export var walk_speed: float = 100.0 # walk speed (px/s)

@export var fire_rate: float = 0.1 # minimum amount of time between shots (s)
@export var max_energy: float = 5 # maximum amount of energy
@export var energy_per_shot: float = 1 # energy cost of shooting once
@export var energy_refill_rate: float = 1.5 # rate at with energy refills automatincally (u/s)
@export var spin_acceleration: float = 200 # rate at witch spin speed increases over time (deg/s^2)
@export var focus_spin_speed: float = 90 # spin speed while focus key is held (deg/s)
@export var fast_spin_speed: float = 360 # starting spin speed when focus key is unpressed (deg/s)
@export var special_attack_speed_threshold: float = 1500 # minimum speed required to use special attack (deg/s)
@export var team: String = "player" # the team attributed to damage created by the player (prevents friendly fire)

@export_file("*.tscn") var bullet_path: String # file path to the bullet that will be spawned by shooting
@export_file("*.tscn") var shockwave_path: String # file path to the bullet that will be spawned by using special

var time_since_last_shot: float = 0.0 # keeps track of time since last shot
var energy: float = max_energy # keeps track of current energy
var spin_speed: float = fast_spin_speed # keeps track of current spin speed


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	#shooting
	if Input.is_action_pressed("shoot"):
		if time_since_last_shot >= fire_rate and energy >= energy_per_shot:
			spawn_bullet(bullet_path)
			time_since_last_shot = 0
			energy -= energy_per_shot 
	
	# walking
	var input_direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	velocity = input_direction * walk_speed
	
	# spinning
	if !Input.is_action_pressed("focus_spin"): #only accelerate if NOT in focus
		spin_speed += spin_acceleration * delta
	rotation_degrees += spin_speed * delta
	
	#change color if special speed threshold is met
	if spin_speed > special_attack_speed_threshold:
		modulate = Color.from_rgba8(255,0,0,255)
	else:
		modulate = Color.from_rgba8(255,255,255,255)
	
	#update time since last shot
	time_since_last_shot += delta
	
	#update energy meter
	if energy < max_energy:
		energy += delta * energy_refill_rate
	else:
		energy = max_energy
	
	move_and_slide()


func spawn_bullet(path):
	#instance bullet
	var packed_bullet: PackedScene = load(path)
	var instanced_bullet: Bullet = packed_bullet.instantiate()
	get_tree().root.get_child(0).add_child(instanced_bullet)
	
	#set bullets position/rotation
	instanced_bullet.damage_team = team
	instanced_bullet.global_position = global_position
	instanced_bullet.rotation = rotation


func _input(event: InputEvent) -> void:
	#handle focus mode
	if event.is_action_pressed("focus_spin"):
		#activate special if fast enough
		if spin_speed >= special_attack_speed_threshold:
			special_attack()
		#set speed
		spin_speed = focus_spin_speed
	if event.is_action_released("focus_spin"):
		#set speed
		spin_speed = fast_spin_speed


func special_attack():
	print("ksldfljk")
	spawn_bullet(shockwave_path)
