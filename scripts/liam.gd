extends Node2D

@onready var button_anim = $button_anim


var dialog = preload("res://scenes/dialog_system.tscn")
var dialog_system: Control
var in_zone = false

func _ready():
	dialog_system = get_tree().get_first_node_in_group("dialogSystem")

func _input(event):
	if Input.is_action_just_pressed("interact") and in_zone == true:
		dialog_system.visible = true
		dialog_system.start_dialog()

func _on_interact_zone_body_entered(body):
	if body.is_in_group("player"):
		button_anim.visible = true
		in_zone = true


func _on_interact_zone_body_exited(body):
	if body.is_in_group("player"):
		button_anim.visible = false
		in_zone = true
