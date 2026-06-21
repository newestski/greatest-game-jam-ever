class_name Bullet # base class that provides utility for all bullets. others should inheret

extends Node2D

@export var velocity: float = 400 # speed of bullet (px/s)
@export var damage: float = 10 # damage delt by bullets
@export var lifespan: float = 20 # amount of time this bullet will exist before deleting itself (s). will last forever if set to -1 

@onready var hurt_box: Area2D = $HurtBox

var damage_team: String


#abstract classes to be overwritten
func on_spawned():
	pass


func on_death():
	pass


func on_movement_step():
	pass # called every physics step after movement is complete


#setting things up
func _ready():
	hurt_box.body_entered.connect(_on_hurt_box_body_entered)
	
	var timer = get_tree().create_timer(lifespan)
	timer.timeout.connect(die)
	
	on_spawned()


func die():
	queue_free()


# deals with movement of bullet
func _physics_process(delta: float) -> void:
	position += Vector2(0,velocity).rotated(rotation) * delta
	on_movement_step()


# deals with damage of bullet
func _on_hurt_box_body_entered(hit: Node2D) -> void:
	var hit_children = hit.get_children()
	if hit is TileMapLayer:
		die()
	if hit_children.any(func(c): return c is HealthComponent):
		var hit_health_component: HealthComponent = hit.get_node("HealthComponent")
		hit_health_component.damage(damage, damage_team)
