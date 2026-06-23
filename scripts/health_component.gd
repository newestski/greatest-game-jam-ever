extends Node

class_name HealthComponent

@export var max_health: float = 100
@export var passive_regen: float = 0.5 # health gained passively over time (hp points per second)
@export var damagable: bool = true
@export var health_team: String 
@export var hurt_sound: AudioStream

var health: float
var damage_queue: float
var character: Node
var dead: bool = false

signal death
signal damaged(health, damage)


func _ready():
	health = max_health
	character = get_parent()


func play_hurt_sound():
	var sound = AudioStreamPlayer2D.new()
	sound.stream = hurt_sound
	print(sound)
	add_child(sound)
	sound.play()
	await sound.finished
	sound.queue_free()


func damage(amount: float, damage_team: String):
	if health_team != damage_team:
		damage_queue += amount


func _process(delta: float) -> void:
	if health <= 0:
		if dead == false:
			die()
	else:
		if damage_queue != 0:
			play_hurt_sound()
			health -= damage_queue
			damaged.emit(health, damage_queue)
			damage_queue = 0
			character.modulate = Color(1.0, 0.0, 0.0, 1.0)
			var tween: Tween = create_tween()
			tween.tween_property(character, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
			print(character.name + " health = " + str(health))
		if health > max_health:
			health = max_health
		health += delta * passive_regen


func die():
	dead = true
	death.emit()
	character.queue_free()
	if get_parent().is_in_group("enemy"):
		get_tree().get_first_node_in_group("game_manager").on_enemy_death()
