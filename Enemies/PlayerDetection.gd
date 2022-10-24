extends Area2D

signal can_see_player(player)
signal lost_player

onready var ray = $RayCast2D

var player = null

func _physics_process(_delta):
	if player != null:
		var collision = ray.get_collider()
		ray.cast_to = global_position.direction_to(player.global_position) * 200
		if collision is Player:
			emit_signal("can_see_player", collision)

func _on_PlayerDetection_body_entered(body):
	player = body
	ray.enabled = true

func _on_PlayerDetection_body_exited(_body):
	ray.enabled = false
	if player != null:
		emit_signal("lost_player")
		player = null
