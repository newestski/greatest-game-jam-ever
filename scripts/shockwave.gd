extends Bullet
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_spawned():
	animation_player.play("shockwave")
