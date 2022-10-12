extends KinematicBody2D

onready var sprite = $Sprite
onready var rotator = $Rotator
onready var flashlight = $Rotator/Flashlight
onready var flashlight_sprite = $Rotator/Flashlight/Sprite
onready var crosshair = $Rotator/Crosshair
onready var animator = $AnimationTree
onready var animation_state = animator.get("parameters/playback")
onready var state_machine = $StateMachine
onready var label = $Label

var velocity : Vector2 = Vector2.ZERO
var hiding : bool = false

func _ready():
	animator.active = true
	
func _process(delta):
	label.text = str(state_machine.state)

func hide():
	sprite.visible = false
	rotator.visible = false
	hiding = true
	state_machine.set_state(state_machine.states.hide)

func reveal():
	sprite.visible = true
	rotator.visible = true
	hiding = false
	state_machine.set_state(state_machine.states.move)

func position_crosshair():
	rotator.look_at(get_global_mouse_position())

	if abs(rotator.rotation_degrees) > 360: 
		rotator.rotation_degrees = 0

	if abs(rotator.rotation_degrees) > 90:
		sprite.flip_h = false
		flashlight_sprite.flip_v = true
	else: 
		sprite.flip_h = true
		flashlight_sprite.flip_v = false
		
func calculate_movement(input_vector, speed, stats, delta):
	rotator.show_behind_parent = input_vector.y < 0
	if input_vector != Vector2.ZERO:
		animator.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * speed, stats.accelleration * delta)
	else: 
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)

func apply_velocity():
	velocity = move_and_slide(velocity)

