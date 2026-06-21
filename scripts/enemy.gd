class_name Enemy

extends CharacterBody2D

@export var speed = 50 # movement speed of enemy (pixels per second)
@export var team: String = "enemy" # the team attributed to damage created by the enemy (prevents friendly fire)
@export var health: float = 20 # amount of health the enemy has
@export var damage: float = 10 # amount of contact damage the enemy does

var target: Node2D


func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	if target:
		var move_direction = (target.position-position).normalized()
		velocity = move_direction * speed
	move_and_slide()


func _on_hurt_box_body_entered(hit: Node2D) -> void:
	var hit_children = hit.get_children()
	if hit_children.any(func(c): return c is HealthComponent):
		var hit_health_component: HealthComponent = hit.get_node("HealthComponent")
		hit_health_component.damage(damage, team)
