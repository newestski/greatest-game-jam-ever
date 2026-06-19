extends Node

class_name HealthComponent

@export var max_health: float = 100
@export var damagable: bool = true
@export var health_team: String 

var health: float
var damage_queue: float
var character: Node
var dead: bool = false

signal death
signal damaged(health, damage)


func _ready():
	health = max_health
	character = get_parent()


func damage(amount: float, damage_team: String):
	if health_team != damage_team:
		damage_queue += amount


func _process(_delta: float) -> void:
	if health <= 0:
		if dead == false:
			die()
	else:
		if damage_queue != 0:
			health -= damage_queue
			damaged.emit(health, damage_queue)
			damage_queue = 0
			character.modulate = Color(1.0, 0.0, 0.0, 1.0)
			var tween: Tween = create_tween()
			tween.tween_property(character, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)
			print(character.name + " health = " + str(health))
		if health > max_health:
			health = max_health


func die():
	dead = true
	death.emit()
	character.queue_free()
