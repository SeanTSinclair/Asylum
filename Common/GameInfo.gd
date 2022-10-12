extends Node

signal all_keys_collected
signal key_collected(amount)

var keys : Array = []
var keys_collected : int = 0

func _ready():
	call_deferred("get_keys_in_scene")
	
func get_keys_in_scene():
	keys.append_array(get_tree().get_nodes_in_group("Keys"))
	
func add_key():
	keys_collected += 1
	emit_signal("key_collected", keys_collected)
	if keys_collected >= keys.size():
		keys_collected = keys.size()
		emit_signal("all_keys_collected")
