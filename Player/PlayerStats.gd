extends Node

# Movement
export var accelleration : float = 500.0
export var friction : float = 500.0
export var base_speed : float = 60.0
export var flashlight_speed_reduction_modifier : float = 0.7

var using_flashlight_speed : float = base_speed * flashlight_speed_reduction_modifier
