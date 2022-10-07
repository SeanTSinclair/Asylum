extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity : Vector2 = Vector2.ZERO

onready var stats = $PlayerStats
onready var movement = $MovementController

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

func move_state(delta):
	var input_vector = movement.get_input_vector()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * stats.base_speed, stats.accelleration * delta)
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
	
	apply_velocity()
	
func apply_velocity():
	velocity = move_and_slide(velocity)
