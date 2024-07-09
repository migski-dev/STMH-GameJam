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
	var player: Player = get_tree().get_first_node_in_group('player')
	if light_blocking_object.is_in_group("interactable_group") and light_blocking_object.has_method("_on_interacted"):
		light_blocking_object._on_interacted()
		player.possession_locked = not player.possession_locked
		if player.possession_locked:
			CameraTransition.transition_camera(player.player_camera, light_blocking_object.possession_camera, 1.0)
		else:
			CameraTransition.transition_camera(light_blocking_object.possession_camera, player.player_camera, 1.0)
		#light_blocking_object.is_interacted = true
