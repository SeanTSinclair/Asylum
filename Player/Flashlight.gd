extends Node2D

onready var light = $Light2D
onready var raycasts = [$Raycasts/RayCast, $Raycasts/RayCast2, $Raycasts/RayCast5, $Raycasts/RayCast3, $Raycasts/RayCast4]

export var stun_amount = 1

var current_targets : Array = []

func _ready():
	disable_flashlight()

func _physics_process(_delta):
	for raycast in raycasts:
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is Ghost:
				if !current_targets.has(collider):
					current_targets.append(collider)
	
	for target in current_targets:
		target.add_stun_amount(stun_amount)
		
	current_targets.clear()

func activate_flashlight():
	set_flashlight(true)

func disable_flashlight():
	set_flashlight(false)

func set_flashlight(active):
	light.enabled = active
	set_physics_process(active)
	current_targets = []
	for raycast in raycasts:
		raycast.enabled = active

