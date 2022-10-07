extends KinematicBody2D

enum {
	MOVE,
	FLASHLIGHT
}

var state = MOVE
var velocity : Vector2 = Vector2.ZERO

onready var stats = $PlayerStats
onready var sprite = $Sprite
onready var movement = $MovementController
onready var animator = $AnimationTree
onready var animation_state = animator.get("parameters/playback")

func _ready():
	animator.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)

func move_state(delta):
	var input_vector = movement.get_input_vector()
	
	if input_vector != Vector2.ZERO:
		animator.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * stats.base_speed, stats.accelleration * delta)
	else: 
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)
	
	apply_velocity()
	
func apply_velocity():
	velocity = move_and_slide(velocity)

