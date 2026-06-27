extends Control
class_name DialogSystem

@onready var character_name = $NinePatchRect/Name
@onready var lines = $NinePatchRect/Text
@onready var choices = $NinePatchRect/choices

@onready var choice_3 = $NinePatchRect/choices/VBoxContainer/choice_3
@onready var choice_4 = $NinePatchRect/choices/VBoxContainer/choice_4


var pause: Control
var player: Node2D
var in_dialog = false
var scene_script: Dictionary
var current_block: Dictionary
var next_block: Dictionary

func _ready() -> void:
	pause = get_tree().get_first_node_in_group("pause_menu")
	player = get_tree().get_first_node_in_group("player")
	add_to_group("dialogSystem")
	if Global.language == "english":
		get_dialog("res://dialogs/en_dialog.json")
	elif Global.language == "polish":
		get_dialog("res://dialogs/pl_dialog.json")

func start_dialog() -> void:
	load_block(current_block)
	in_dialog = true
	pause.pausable = false
	player.talking = true

func _input(event) -> void:
	if event.is_action_pressed("interact") and in_dialog == true:
		next()

func get_dialog(path: String) -> void:
	var json_file = FileAccess.get_file_as_string(path)
	scene_script = JSON.parse_string(json_file)
	current_block = scene_script["im lazy"]

func load_block(block: Dictionary) -> void:
	if block.has("name"):
		character_name.text = format_text(block["name"])
	if block.has("text"):
		lines.text = block["text"]
	if block.has("next"):
		var key = block["next"]
		next_block = scene_script[key]
	if block.has("choice"):
		choices.visible = true
		choices.set_choices(block["choice"])
	if block.has("END"):
		in_dialog = false
		pause.pausable = true
		player.talking = false
		visible = false
		print("koniec dialogu")


func next() -> void:
	current_block = next_block
	print(next_block)
	load_block(current_block)


func _on_choices_next_key(key2) -> void:
	next_block = scene_script[key2]
	next()
	choices.visible = false


func format_text(text: String) -> String:
	return text.format({"player_name": Global.player_name})
