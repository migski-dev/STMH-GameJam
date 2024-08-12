extends Node

signal on_player_enter_new_shadow(object: CollisionObject3D)

var current_light:  Light3D
var light_blocking_object
var lbo_instance
var is_interacted: bool = false
var possession_mode = false
var player: Player

func _ready():
	player = get_tree().get_first_node_in_group('player')
	CameraTransition.possession_enter_complete.connect(_on_possession_enter_complete)

func is_light_blocking_object_moving() -> bool:
	if(light_blocking_object == null):
		return false
	return light_blocking_object.is_in_group('moving_objects') || light_blocking_object.get_owner().is_in_group('moving_objects')

func is_light_blocking_object_interactable() -> bool:
	if(light_blocking_object == null):
		return false
	return light_blocking_object.is_in_group('interactable_group') || light_blocking_object.get_owner().is_in_group('interactable_group')

func _on_possession_enter_complete() -> void:
	print_debug('removed player from tree')
	get_tree().get_first_node_in_group('levels').remove_child(player)
	
func on_player_exit_possession(casted_shadow_position: Vector3) -> void:
	get_tree().get_first_node_in_group('levels').add_child(player)
	player = get_tree().get_first_node_in_group('player')
	player.movement_locked = true
	player.global_transform.origin = casted_shadow_position
	CameraTransition.transition_camera(get_viewport().get_camera_3d(), player.player_camera)

