extends Bullet
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func on_spawned():
	print("sdjksdlg;")
	animation_player.play("shockwave")
