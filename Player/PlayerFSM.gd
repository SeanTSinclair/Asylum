extends StateMachine

# https://www.youtube.com/watch?v=j_pM3CiQwts&list=RDCMUCLweX1UtQjRjj7rs_0XQ2Eg&index=2

onready var stats = $PlayerStats

func _ready():
	add_state("move")
	add_state("flashlight")
	add_state("hide")
	add_state("dead")
	call_deferred("set_state", states.move)
	
func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return input_vector.normalized()

func _state_logic(delta):
	if state == states.move:
		parent.calculate_movement(get_input_vector(), stats.base_speed, stats, delta)
	if state == states.flashlight:
		parent.calculate_movement(get_input_vector(), stats.using_flashlight_speed, stats, delta)
	if state == states.hide:
		parent.velocity = Vector2.ZERO
		
	parent.position_crosshair()
	parent.apply_velocity()
	
func _get_transition(_delta):
	match state:
		states.move:
			if Input.is_action_pressed("flashlight"):
				return states.flashlight
		states.flashlight:
			if !Input.is_action_pressed("flashlight"):
				return states.move
	
func _enter_state(new_state, _old_state):
	if new_state == states.flashlight:
		parent.flashlight.activate_flashlight()
		parent.crosshair.visible = false
	
func _exit_state(old_state, _new_state):
	if old_state == states.flashlight:
		parent.flashlight.disable_flashlight()
		parent.crosshair.visible = true
