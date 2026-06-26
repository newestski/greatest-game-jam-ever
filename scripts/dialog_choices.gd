extends Control

@onready var container = $VBoxContainer

@export var b_group: ButtonGroup

var dialog_choices: Dictionary

signal next_key(key2: String)

func _ready() -> void:
	for b in container.get_children():
		b.pressed.connect(get_choice.bind(b))

func set_choices(choices: Dictionary) -> void:
	dialog_choices = choices
	visible = true
	var buttons = container.get_children()
	var index = 0
	for button in buttons:
		button.visible = false
	for choice in choices.keys():
		if index >= buttons.size():
			break
		buttons[index].text = choice
		buttons[index].visible = true
		index += 1
		

func get_choice(b: Button) -> void:
	var key2 = dialog_choices[b.text]
	next_key.emit(key2)
