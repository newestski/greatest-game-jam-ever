extends Bullet
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func on_spawned():
	animation_player.play("shockwave")
