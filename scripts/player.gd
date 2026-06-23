class_name Player

extends CharacterBody2D

var tracer = preload("res://scenes/bullets/tracer.tscn").instantiate()

@onready var health_component: HealthComponent = $HealthComponent
@onready var ray = $gun_position/shot #raycast for gun
@onready var reload_timer = $gun_position/reload_timer
@onready var firerate_timer = $gun_position/firerate_timer
@onready var gun_position = $gun_position
@onready var reload_sound: AudioStreamPlayer2D = $gun_position/ReloadSound
@onready var shoot_sound: AudioStreamPlayer2D = $gun_position/ShootSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@export var reload_speed: float = 0.7 #time to load every bullet
@export var firerate: float = 0.4 #time between shots
@export var damage: int = 30 #revolver damage
@export var walk_speed: float = 100.0 # walk speed (px/s)
@export var spin_acceleration: float = 200 # rate at witch spin speed increases over time (deg/s^2)
@export var focus_spin_speed: float = 90 # spin speed while focus key is held (deg/s)
@export var fast_spin_speed: float = 360 # starting spin speed when focus key is unpressed (deg/s)
@export var special_attack_speed_threshold: float = 1500 # minimum speed required to use special attack (deg/s)
@export var team: String = "player" # the team attributed to damage created by the player (prevents friendly fire)

@export_file("*.tscn") var bullet_path: String # file path to the bullet that will be spawned by shooting
@export_file("*.tscn") var shockwave_path: String # file path to the bullet that will be spawned by using special

const MAX_AMMO = 6 #the max ammunition for revolver

var game_manager: GameManager
var game_ui: MainGameUI

var spin_speed: float = fast_spin_speed # keeps track of current spin speed
var damage_team: String
var reloading: bool = false #checks if you are reloding rn
var firerate_cooldown: bool = false #stops you from spamming
var ammunition: int = 6 #current ammunition
var dead: bool = false #checks if the player is currently dead



func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")
	game_ui = get_tree().get_first_node_in_group("game_ui")


func _physics_process(delta: float) -> void:
	#disables movement if dead
	if dead:
		velocity *= 0.5
		move_and_slide()
		return
	
	#shooting
	if Input.is_action_just_pressed("shoot"):
		if ammunition > 0 and reloading == false and firerate_cooldown == false:
			shooting()

	#reloading
	if Input.is_action_just_pressed("reload"):
		if ammunition < MAX_AMMO and reloading == false: #chceks if your ammunition is less than full and if you arent arleady reloading
			reload((MAX_AMMO - ammunition)) #says how much money we have to load in

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
	
	move_and_slide()


#called by the player's health component on death
func on_death():
	dead = true
	death_sound.play()


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
	spawn_bullet(shockwave_path)


func shooting():
	game_ui.revolver_graphic.spend_bullet() #tells revolver graphic in ui to animate
	shoot_sound.play()
	ammunition -= 1 #substracts the ammunition
	fireratetimer()
	var start_pos = gun_position.global_position #starting position for drawing tracer
	var end_pos: Vector2 #end position for drawing tracer
	if ray.is_colliding():
		end_pos = ray.get_collision_point()
		var victim = ray.get_collider() #sets the victim to the object we hit
		print(victim.name)
		if victim.get_children().any(func(c): return c is HealthComponent):
			var hit_health_component: HealthComponent = victim.get_node("HealthComponent")
			hit_health_component.damage(damage, damage_team)
		else:
			pass
	else:
		end_pos = ray.to_global(ray.target_position) #if it misses entirely and the raycats runs out this will set the end position for tracer
	
	if !tracer.get_parent(): get_tree().current_scene.add_child(tracer) #spawns tracer
	tracer.bullet_tracer(start_pos, end_pos) #calls the tracer function


func fireratetimer():
	firerate_cooldown = true
	firerate_timer.wait_time = firerate
	firerate_timer.start()


func _on_firerate_timer_timeout():
	firerate_cooldown = false


func reload(amount):
	reloading = true
	reload_timer.wait_time = reload_speed
	for bullet in amount: #loads the bullets in chambers
		reload_timer.start()
		await reload_timer.timeout
		ammunition += 1
		reload_sound.play() #plays sound
		game_ui.revolver_graphic.reload_bullet() #tells revolver graphic in ui to animate
	reloading = false
