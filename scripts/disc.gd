extends Bullet

@export var acceleration = 300

func on_movement_step(delta):
	velocity += delta * acceleration
