extends KinematicBody2D
class_name Ghost

const STUN_THRESHOLD = 100
const PUSH_FORCE = 400
const STUN_REDUCTION_AMOUNT = 2

onready var collision = $CollisionShape2D
onready var animated_sprite = $AnimatedSprite
onready var state_machine = $GhostFSM
onready var stun_timer = $StunTimer
onready var stun_reduction_timer = $StunReductionTimer
onready var wander_controller = $WanderController
onready var soft_collision = $SoftCollision
onready var state_label = $Label # TODO: Remove later maybe? 

export var speed = 45
export var accelleration = 200
export var friction = 200

var stun_amount : float = 0
var velocity = Vector2.ZERO

func _physics_process(delta):
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * PUSH_FORCE
	
	velocity = move_and_slide(velocity)

func accellerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * speed, accelleration * delta)
	
func move_to_wander_target(delta):
	accellerate_towards_point(wander_controller.target_position, delta) 

func add_stun_amount(player, amount):
	if !is_stunned():
		state_machine.is_attacked_by(player)
		stun_amount += amount
		animated_sprite.material.set_shader_param("stun_amount", stun_amount / STUN_THRESHOLD)
		if stun_amount >= STUN_THRESHOLD:
			state_machine.is_stunned = true
			collision.disabled = true
			stun_timer.start(stun_timer.wait_time)
			
func is_stunned() -> bool:
	return state_machine.state == state_machine.states.stunned
			
func slow_to_stop(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func distance_to_wander_target() -> float:
	return global_position.distance_to(wander_controller.target_position)

func _on_StunTimer_timeout():
	stun_amount = 0
	state_machine.is_stunned = false
	collision.disabled = false
	animated_sprite.material.set_shader_param("stun_amount", stun_amount / STUN_THRESHOLD)

func _on_GhostFSM_changed_state(new_state):
	state_label.text = str(new_state)

func _on_StunReductionTimer_timeout():
	if !is_stunned():
		stun_amount -= STUN_REDUCTION_AMOUNT
		stun_amount = max(0, stun_amount)
		animated_sprite.material.set_shader_param("stun_amount", stun_amount / STUN_THRESHOLD)
