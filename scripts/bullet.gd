class_name Bullet
# this is a base class and should be inhereted for other bullets

extends Node2D

@export var velocity: float = 400 # speed of bullet (pixels per second)
@export var damage = 10 #damage delt by bullets

@onready var hurt_box: Area2D = $HurtBox

var damage_team: String

func _ready():
	hurt_box.body_entered.connect(_on_hurt_box_body_entered)
	_on_spawned()


func _on_spawned():
	pass


func die():
	queue_free()


func _physics_process(delta: float) -> void:
	position += Vector2(0,velocity).rotated(rotation) * delta


func _on_hurt_box_body_entered(hit: Node2D) -> void:
	var hit_children = hit.get_children()
	if hit is TileMapLayer:
		die()
	if hit_children.any(func(c): return c is HealthComponent):
		var hit_health_component: HealthComponent = hit.get_node("HealthComponent")
		hit_health_component.damage(damage, damage_team)
