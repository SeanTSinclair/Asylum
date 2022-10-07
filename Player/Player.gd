extends KinematicBody2D

onready var stats = $PlayerStats
onready var sprite = $Sprite
onready var flashlight = $Rotator/Flashlight
onready var rotator = $Rotator
onready var movement = $MovementController
onready var animator = $AnimationTree
onready var animation_state = animator.get("parameters/playback")

enum State {
	MOVE,
	FLASHLIGHT
}
var state = State.MOVE

var velocity : Vector2 = Vector2.ZERO
var flashlight_direction : Vector2 = Vector2.DOWN

func _ready():
	animator.active = true
	flashlight.visible = false

func _physics_process(delta):
	match state:
		State.MOVE:
			move_state(delta)
		State.FLASHLIGHT:
			flashlight_state(delta)
			
	position_crosshair()
	
	if Input.is_action_pressed("flashlight"):
		flashlight.visible = true
		state = State.FLASHLIGHT
	elif Input.is_action_just_released("flashlight"):
		flashlight.visible = false
		state = State.MOVE

func move_state(delta):
	calculate_movement(movement.get_input_vector(), stats.base_speed, delta)
	apply_velocity()
	
func flashlight_state(delta):
	calculate_movement(movement.get_input_vector(), stats.using_flashlight_speed, delta)
	apply_velocity()
	
func position_crosshair():
	rotator.look_at(get_global_mouse_position())
	
	if abs(rotator.rotation_degrees) > 360: 
		rotator.rotation_degrees = 0
		
	if abs(rotator.rotation_degrees) > 90:
		sprite.flip_h = false
		flashlight.flip_v = true
	else: 
		sprite.flip_h = true
		flashlight.flip_v = false
		

func calculate_movement(input_vector, speed, delta): 
	if input_vector != Vector2.ZERO:
		animator.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * speed, stats.accelleration * delta)
	else: 
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)

func apply_velocity():
	velocity = move_and_slide(velocity)

