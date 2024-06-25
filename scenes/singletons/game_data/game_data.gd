extends Node

var current_light:  Light3D
var light_blocking_object
var local_collision_position: Vector3

func is_light_blocking_object_moving() -> bool:
	if(light_blocking_object == null):
		return false
	return light_blocking_object.is_in_group('moving_objects')
