extends Control

@onready var en_icon = $american_flag
@onready var pl_icon = $polish_flag


func _physics_process(delta):
	if Global.language == "english":
		en_icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
		pl_icon.modulate = Color(0.115, 0.115, 0.115, 0.851)
	elif Global.language == "polish":
		pl_icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
		en_icon.modulate = Color(0.115, 0.115, 0.115, 0.851)

func _on_english_pressed():
	Global.language = "english"
	print(Global.language)


func _on_polish_pressed():
	Global.language = "polish"
	print(Global.language)
