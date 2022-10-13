extends StateMachine

var player = null
var is_stunned = false

func _ready():
	add_state("idle")
	add_state("wander")
	add_state("chase")
	add_state("stunned")
	call_deferred("set_state", states.idle)

func _state_logic(_delta):
	pass
	
func _get_transition(_delta):
	match state:
		states.idle:
			if player != null:
				return states.chase
			if is_stunned:
				return states.stunned
		states.wander: 
			if player != null:
				return states.chase
			if is_stunned:
				return states.stunned
		states.chase:
			if player == null:
				return states.idle
			if is_stunned:
				return states.stunned
		states.stunned:
			if !is_stunned: 
				return states.idle
	return null
	
func _enter_state(new_state, old_state):
	print("Entering " + str(new_state) + " from " + str(old_state))
	pass
	
func _exit_state(old_state, new_state):
	pass

func _on_PlayerDetection_can_see_player(player):
	self.player = player

func _on_PlayerDetection_lost_player():
	player = null
