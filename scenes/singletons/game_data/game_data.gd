extends Node

var current_light:  Light3D
var light_blocking_object

func on_player_interact():
	if light_blocking_object.is_in_group("interactable_group") and light_blocking_object.has_method("_on_interacted"):
		light_blocking_object._on_interacted()
