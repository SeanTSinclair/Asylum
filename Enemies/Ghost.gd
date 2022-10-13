extends Area2D
class_name Ghost

const STUN_THRESHOLD = 100

onready var collision = $CollisionShape2D
onready var animated_sprite = $AnimatedSprite
onready var state_machine = $GhostFSM
onready var stun_timer = $StunTimer

var stun_amount : float = 0

func add_stun_amount(amount):
	if state_machine.state != state_machine.states.stunned:
		stun_amount += amount
		animated_sprite.material.set_shader_param("stun_amount", stun_amount / STUN_THRESHOLD)
		if stun_amount >= STUN_THRESHOLD:
			state_machine.is_stunned = true
			collision.disabled = true
			stun_timer.start(stun_timer.wait_time)

func _on_StunTimer_timeout():
	stun_amount = 0
	state_machine.is_stunned = false
	animated_sprite.material.set_shader_param("stun_amount", stun_amount / STUN_THRESHOLD)
