extends Node3D

signal player_in_light()
signal on_target_in_light()

@export var player: CharacterBody3D
@onready var target_raycast: RayCast3D = $TargetRaycast

var light_blocked_flag: bool = false 

func _physics_process(delta):
	if check_player_outline():
		player.is_in_shadow = true
	else: 
		player.is_in_shadow = false

		
func check_player_outline() -> bool:
	var raycast_array = get_tree().get_nodes_in_group('light_raycasts') as Array[RayCast3D]
	var player_position = player.global_transform.origin
	
	for raycast in raycast_array:
		raycast_to_light_source(raycast, player_position)
		if raycast.is_colliding(): 
			GameData.light_blocking_object = raycast.get_collider()
			return true
	
	return false
		

func raycast_to_light_source(raycast: RayCast3D, start_position: Vector3) -> void:
	var light_dir: Vector3 = GameData.current_light.global_transform.basis.z.normalized() # Direction of Light
	var light_pos: Vector3 = start_position - light_dir * 1000 # Large Distance in Direction of Light
	
	raycast.target_position = start_position - light_pos
	raycast.add_exception(player)
	raycast.force_raycast_update()

# Returns true if the target position is in the shadow; false if in the light
func check_valid_move(target_source: Vector3) -> bool:
	target_raycast.global_transform.origin = target_source
	raycast_to_light_source(target_raycast, target_raycast.position)
	
	if target_raycast.is_colliding():
		return true	
	else:
		return false

