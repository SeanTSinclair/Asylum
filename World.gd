extends Node2D

onready var key_collected_text = $CanvasLayer/HBoxContainer/KeysCollected
onready var keys_total = $CanvasLayer/HBoxContainer/KeysTotal
onready var complete_text = $CanvasLayer/Complete
onready var complete_tweener = $CanvasLayer/Complete/Tween

func _ready():
	GameInfo.connect("key_collected", self, "update_keys_collected")
	GameInfo.connect("all_keys_collected", self, "show_door_unlocked_text")
	call_deferred("set_total_keys_text")
	randomize()
	
func set_total_keys_text():
	keys_total.text = str(GameInfo.keys.size())
	
func update_keys_collected(amount):
	key_collected_text.text = str(amount) + " /"

func show_door_unlocked_text():
	complete_tweener.interpolate_property(complete_text, "percent_visible", 0, 1, 1, Tween.TRANS_CUBIC)
	complete_tweener.start()
	complete_tweener.connect("tween_all_completed", self, "hide_door_unlocked_text")
	
func hide_door_unlocked_text():
	complete_tweener.seek(0)
	complete_tweener.interpolate_property(complete_text, "percent_visible", 1, 0, 3, Tween.TRANS_CUBIC)
	complete_tweener.start()
	complete_tweener.disconnect("tween_all_completed", self, "hide_door_unlocked_text")
	complete_tweener.connect("tween_all_completed", complete_tweener, "queue_free")
