extends KinematicBody2D

onready var stats = $PlayerStats
onready var sprite = $Sprite
onready var rotator = $Rotator
onready var flashlight = $Rotator/Flashlight
onready var flashlight_sprite = $Rotator/Flashlight/Sprite
onready var crosshair = $Rotator/Crosshair
onready var movement = $MovementController
onready var animator = $AnimationTree
onready var animation_state = animator.get("parameters/playback")

enum {
	MOVE,
	FLASHLIGHT
}
var state = MOVE

var velocity : Vector2 = Vector2.ZERO
var flashlight_direction : Vector2 = Vector2.DOWN

func _ready():
	animator.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		FLASHLIGHT:
			flashlight_state(delta)
			
	position_crosshair()
	
	if Input.is_action_pressed("flashlight"):
		flashlight.activate_flashlight()
		crosshair.visible = false
		state = FLASHLIGHT
	elif Input.is_action_just_released("flashlight"):
		flashlight.disable_flashlight()
		crosshair.visible = true
		state = MOVE


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
		flashlight_sprite.flip_v = true
	else: 
		sprite.flip_h = true
		flashlight_sprite.flip_v = false
		

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

