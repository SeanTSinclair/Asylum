extends Area2D
class_name Ghost

const STUN_THRESHOLD = 100

onready var collision = $CollisionShape2D
onready var animated_sprite = $AnimatedSprite

enum { 
	IDLE,
	WANDER,
	CHASE,
	STUNNED
}

var state = IDLE
var stun_amount : float = 0

func _physics_process(_delta):
	match state:
		IDLE:
			pass
		WANDER:
			pass
		CHASE:
			pass
		STUNNED:
			pass

func add_stun_amount(amount):
	if state != STUNNED:
		stun_amount += amount
		animated_sprite.material.set_shader_param("stun_amount", stun_amount / STUN_THRESHOLD)
		if stun_amount >= STUN_THRESHOLD:
			state = STUNNED
			collision.disabled = true
			print("Ghost %s is stunned!" % name)
			
func reset_stun():
	state = IDLE
	stun_amount = 0
	collision.disabled = false
	
