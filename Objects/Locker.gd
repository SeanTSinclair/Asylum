extends Interactable

var is_hiding_player : bool = false

func _interaction_logic(player):
	if is_hiding_player:
		player.reveal()
	else: 
		player.hide()
	is_hiding_player = !is_hiding_player
