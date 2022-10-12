extends Area2D

onready var interaction_icon_instance = preload("res://Common/InteractionIcon.tscn")
var interactables_in_range : Array = []
var current_icon = null

func _ready():
	var check_timer = get_tree().create_timer(.2)
	check_timer.connect("timeout", self, "update_interaction_icon")
	
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		var closest = get_nearest_interactable()
		if closest != null:
			if closest.has_method("interact"):
				closest.interact(owner)

func update_interaction_icon():
	if interactables_in_range.size() != 0:
		var closest = get_nearest_interactable()
		var position = closest.get_node("InteractionIconPosition").global_position
		if position == null:
			printerr("InteractionIconPosition node not present on " + closest.name)
			return
		current_icon = interaction_icon_instance.instance()
		current_icon.global_position = position
		get_tree().current_scene.add_child(current_icon)
	elif current_icon != null:
		current_icon.queue_free()
		current_icon = null
			
func get_nearest_interactable():
		var closest = null 
		for interactable in interactables_in_range:
			if closest == null:
				closest = interactable
			elif global_position.distance_to(interactable.global_position) < global_position.distance_to(closest.global_position):
				closest = interactable
		return closest

func _on_InteractionController_area_entered(area):
	interactables_in_range.append(area)
	update_interaction_icon()
	
func _on_InteractionController_area_exited(area):
	interactables_in_range.remove(interactables_in_range.find(area))
	update_interaction_icon()
	
