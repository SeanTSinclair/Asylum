extends Node
class_name Interactable

var is_interacting_with : bool = false

func interact(player):
	_interaction_logic(player)

func _interaction_logic(_player):
	pass
