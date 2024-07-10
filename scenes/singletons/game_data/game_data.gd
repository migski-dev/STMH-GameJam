extends Node

var current_light:  Light3D
var light_blocking_object
var local_collision_position: Vector3
var is_interacted: bool = false
var player: Player

func _ready():
	player = get_tree().get_first_node_in_group('player')

func is_light_blocking_object_moving() -> bool:
	if(light_blocking_object == null):
		return false
	return light_blocking_object.is_in_group('moving_objects') || light_blocking_object.get_owner().is_in_group('moving_objects')

func is_light_blocking_object_interactable() -> bool:
	if(light_blocking_object == null):
		return false
	return light_blocking_object.is_in_group('interactable_group') || light_blocking_object.get_owner().is_in_group('interactable_group')



func on_player_interact():
	pass
	if is_light_blocking_object_interactable() and light_blocking_object.get_owner().has_method("_on_interacted"):
		if player.possession_locked:
			CameraTransition.transition_camera(player.player_camera, light_blocking_object.get_owner().possession_camera, 1.0)
		else:
			var test = light_blocking_object.get_owner().possession_camera
			light_blocking_object.get_owner()._on_interacted()
			CameraTransition.transition_camera(light_blocking_object.get_owner().possession_camera, player.player_camera, 1.0)
		#light_blocking_object.is_interacted = true
