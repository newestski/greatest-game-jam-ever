extends Control
class_name shop

@export var shop_slot: PackedScene
@export var slots_container: HBoxContainer

func _ready() -> void: #spawns the shop_slots
	for i in range(3):
		var shop_slot_instance = shop_slot.instantiate()
		slots_container.add_child(shop_slot_instance)
