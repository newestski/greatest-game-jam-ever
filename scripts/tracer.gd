extends Line2D

func bullet_tracer(start_pos: Vector2, end_pos: Vector2):
	clear_points() #clears everything
	add_point(to_local(start_pos)) #starting point
	add_point(to_local(end_pos)) #finish point

	visible = true

	await get_tree().create_timer(0.05).timeout #time before dissapering
	visible = false
