extends Camera2D

var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")


func _process(delta):
	if player:
		global_position = player.global_position.snapped(Vector2(1, 1))
