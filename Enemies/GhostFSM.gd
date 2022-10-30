extends StateMachine

const STOP_DISTANCE = 10

var player = null
var is_stunned = false

func _ready():
	randomize()
	add_state("idle")
	add_state("wander")
	add_state("chase")
	add_state("stunned")
	call_deferred("set_state", states.idle)
	
func _physics_process(delta):
	if player != null:
		print(OS.get_time())

func _state_logic(delta):
	if state == states.idle: 
		parent.slow_to_stop(delta)
		update_passive_state()
	if state == states.wander:
		update_passive_state()
		wander(delta)
	if state == states.chase:
		move_to_player(delta)
	if state == states.stunned:
		parent.slow_to_stop(delta) 
	
func update_passive_state():
	if parent.wander_controller.get_time_left() == 0:
		choose_passive_state()
		
func choose_passive_state():
	var passive_states = [states.idle, states.wander]
	passive_states.shuffle()
	set_state(passive_states.pop_front())
	parent.wander_controller.start_timer(rand_range(1, 3))
	
func is_attacked_by(player):
	if state != states.chase:
		self.player = player
		set_state(states.chase)

func move_to_player(delta):
	if player != null:
		if parent.global_position.distance_to(player.global_position) > STOP_DISTANCE:
			parent.accellerate_towards_point(player.global_position, delta)
	
func wander(delta):
	parent.move_to_wander_target(delta)
	if parent.distance_to_wander_target() < parent.speed * delta:
		choose_passive_state()
	
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
	pass
	
func _exit_state(old_state, new_state):
	if old_state == states.chase && player != null:
		player = null

func _on_PlayerDetection_can_see_player(col):
	self.player = col

func _on_PlayerDetection_lost_player():
	player = null
