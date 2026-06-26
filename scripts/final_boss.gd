extends Enemy

@onready var teleport_particles: CPUParticles2D = $TeleportParticles
@onready var teleport_sound: AudioStreamPlayer2D = $TeleportSound
@onready var charge_dash_sound: AudioStreamPlayer2D = $ChargeDashSound
@onready var dash_sound: AudioStreamPlayer2D = $DashSound
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var sight_distance: float = 200  # distance at witch enemy will start attacking you (px)
@export var center_disc_beam_state_time: float = 6
@export var dash_charge_time: float = 1
@export var dash_time: float = 1
@export var summon_enemies_time: float = 1
@export var number_of_dashes: int = 3
@export var teleport_time: float = 1
@export var time_before_fight: float = 1
@export var time_after_fight: float = 3
@export var time_between_contact_damages: float = 0.1

var disc_path = "res://scenes/bullets/disc.tscn" #file path of bullet
var contact_damage_path = "res://scenes/bullets/final_boss_melee.tscn" #file path of contact damage bullet

enum states{
	IDLE, 
	WAITING, 
	CENTER_DISC_BEAM, 
	CENTER_DISC_BEAM_TELEPORT, 
	CORNER_DISC_BEAM, 
	CORNER_DISC_BEAM_TELEPORT, 
	DASH_CHARGE, 
	DASH,
	SUMMON_ENEMIES
}


var contact_damage_enabled = false
var time_since_last_contact_damage = 0
var state: states = states.IDLE
var last_attack: states
var time_since_last_shot: float = 0
var time_since_last_attack_change: float = 0
var attack_repititions: int = 0
var waypoint_positions: Array[Vector2]
var origin_position: Vector2
var music_manager: MusicManager
var game_manager: GameManager
var game_ui: MainGameUI
var win_menu: WinMenu

#yeah this code is unreadable and i didn't comment it at all
#sorry.

func on_spawn():
	waypoint_positions = get_waypoint_positions()
	origin_position = position
	animated_sprite_2d.play("idle")
	
	game_ui = get_tree().get_first_node_in_group("game_ui")
	music_manager = get_tree().get_first_node_in_group("music_manager")
	game_manager = get_tree().get_first_node_in_group("game_manager")
	win_menu =  game_ui.win_menu
	
	music_manager.fade_out()


func on_death():
	music_manager.weirdly_chill_boss_theme.stop()
	win_menu.open(time_after_fight)
	game_manager.clear_all_enemies()

func _process(_delta: float) -> void:
	#flipping sprite to face player
	if animated_sprite_2d.position.x - target.position.x > 0 :
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

func on_physics_proccess(delta: float) -> void:
	if !target: return # prevents crash if player is freed
	time_since_last_shot += delta
	time_since_last_attack_change += delta
	time_since_last_contact_damage += delta
	velocity *= 0.95

	if contact_damage_enabled and time_since_last_contact_damage > time_between_contact_damages:
		shoot_at_position(contact_damage_path, Vector2(0,0))
		time_since_last_contact_damage = 0
	
	if state == states.IDLE and check_distance_to_point(target.position) < sight_distance:
		animated_sprite_2d.play("idle")
		state = states.WAITING
		time_since_last_attack_change = 0
		music_manager.weirdly_chill_boss_theme.play()
		game_ui.boss_bar.assign_boss_bar(self)
		#making a barrier (god forgive me for this)
		var tile = Vector2i(0,4)
		game_manager.current_level.tile_map_layer.set_cell(Vector2i(-3, -25), 0, tile)
		game_manager.current_level.tile_map_layer.set_cell(Vector2i(-2, -25), 0, tile)
		game_manager.current_level.tile_map_layer.set_cell(Vector2i(-1, -25), 0, tile)
		game_manager.current_level.tile_map_layer.set_cell(Vector2i(0, -25), 0, tile)
		game_manager.current_level.tile_map_layer.set_cell(Vector2i(1, -25), 0, tile)

		
		await get_tree().create_timer(time_before_fight).timeout
		state = pick_random_state()
	
	elif state == states.CENTER_DISC_BEAM_TELEPORT:
		state = states.WAITING
		await teleport(origin_position)
		animated_sprite_2d.play("shoot")
		state = states.CENTER_DISC_BEAM
	
	elif state == states.CENTER_DISC_BEAM:
		if time_since_last_shot > 0.1:
			shoot_at_position(disc_path, target.position)
			time_since_last_shot = 0
		if time_since_last_attack_change > center_disc_beam_state_time:
			time_since_last_attack_change = 0
			state = pick_random_state()
	
	elif state == states.CORNER_DISC_BEAM_TELEPORT:
		state = states.WAITING
		await teleport(waypoint_positions.pick_random())
		animated_sprite_2d.play("shoot")
		state = states.CORNER_DISC_BEAM
	
	elif state == states.CORNER_DISC_BEAM:
		if time_since_last_shot > 0.2:
			shoot_at_position(disc_path, target.position)
			time_since_last_shot = 0
		if time_since_last_attack_change > center_disc_beam_state_time:
			time_since_last_attack_change = 0
			state = pick_random_state()
	
	elif state == states.DASH_CHARGE:
		animated_sprite_2d.play("dash_charge")
		state = states.WAITING
		charge_dash_sound.play()
		await get_tree().create_timer(dash_charge_time).timeout
		state = states.DASH
	
	elif state == states.DASH:
		animated_sprite_2d.play("dash")
		contact_damage_enabled = true
		dash_sound.play()
		velocity = (target.position-position).normalized() * 500
		attack_repititions += 1
		state = states.WAITING
		await get_tree().create_timer(dash_time).timeout
		contact_damage_enabled = false
		if attack_repititions >= number_of_dashes:
			state = pick_random_state()
		else:
			state = states.DASH_CHARGE

	
	elif state == states.SUMMON_ENEMIES:
		animated_sprite_2d.play("idle")
		var enemy = await game_manager.spawn_enemy(game_manager.get_random_enemy(), waypoint_positions.pick_random())
		var summon_particles = teleport_particles.duplicate()
		teleport_sound.play()
		enemy.add_child(summon_particles)
		summon_particles.emitting = true
		state = states.WAITING
		await get_tree().create_timer(summon_enemies_time).timeout
		summon_particles.queue_free()
		state = pick_random_state()
	move_and_slide()


func teleport(target_position: Vector2):
	#spawn particles on origin
	animated_sprite_2d.play("teleport")
	var origin_particles: CPUParticles2D = teleport_particles.duplicate()
	add_child(origin_particles)
	teleport_sound.play()

	origin_particles.emitting = true
	position = target_position
	teleport_particles.emitting = true
	await get_tree().create_timer(teleport_time).timeout
	origin_particles.queue_free()


func get_waypoint_positions():
	var positions: Array[Vector2]
	var waypoint_nodes: Array[Node] = get_tree().get_nodes_in_group("boss_waypoint")
	for node in waypoint_nodes:
		positions.append(node.position) 
	return positions


func pick_random_state():
	time_since_last_attack_change = 0
	attack_repititions = 0
	var avaliable_states = [states.CENTER_DISC_BEAM_TELEPORT, states.CORNER_DISC_BEAM_TELEPORT, states.DASH_CHARGE, states.SUMMON_ENEMIES]
	avaliable_states.erase(last_attack)
	var random: states
	random = avaliable_states.pick_random()
	last_attack = random
	return random
