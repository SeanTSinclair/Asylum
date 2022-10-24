extends Area2D

func is_colliding() -> bool:
	var collisions = get_overlapping_areas()
	return collisions.size() > 0
	
func get_push_vector() -> Vector2:
	if !is_colliding():
		return Vector2.ZERO
	
	var collisions = get_overlapping_areas()
	var collision = collisions[0]
	
	var push_vector = collision.global_position.direction_to(global_position)
	push_vector = push_vector.normalized()
	
	return push_vector
