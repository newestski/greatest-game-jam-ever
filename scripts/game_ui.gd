class_name MainGameUI

extends Control

@onready var floor_counter: Label = $FloorCounter
@onready var player: Player = %Player
@onready var game_manager: GameManager = %GameManager
@onready var ammocounter = $ammocounter
@onready var revolver_graphic: RevolverGraphic = $RevolverGraphic
@onready var health_bar: Control = $HealthBar


func _process(_delta: float) -> void:
	if player:
		floor_counter.text = "Floor " + str(game_manager.current_floor)
		ammocounter.text = "ammunition " + str(player.ammunition)
