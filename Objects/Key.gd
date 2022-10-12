extends Interactable

func _ready():
	add_to_group("Keys")

func _interaction_logic(_player):
	GameInfo.add_key()
	queue_free()
