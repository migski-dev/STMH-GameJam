extends Node

var current_light:  Light3D
var light_blocking_object
var local_collision_position: Vector3
var is_interacted: bool = false

func is_light_blocking_object_moving() -> bool:
	if(light_blocking_object == null):
		return false
	return light_blocking_object.is_in_group('moving_objects')

func on_player_interact():
	if light_blocking_object.is_in_group("interactable_group") and light_blocking_object.has_method("_on_interacted"):
		light_blocking_object._on_interacted()
		light_blocking_object.is_interacted = true
