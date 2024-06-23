extends Node3D

signal player_in_light()
signal on_target_in_light()

@export var player: CharacterBody3D 
@onready var target_raycast: RayCast3D = $TargetRaycast

var light_blocked_flag: bool = false 
@export var player_raycast: RayCast3D 

func _physics_process(delta):
	if is_in_shadow():
		player.is_in_shadow = true
		
	else: 
		player.is_in_shadow = false

		
func is_in_shadow() -> bool:
	var raycast_array = get_tree().get_nodes_in_group('light_raycasts') as Array[RayCast3D]
	var light_raycast = player_raycast
	var player_position = player.global_transform.origin
	var light_check = true
	#raycast_to_light_source(light_raycast, player_position)
	#if not light_raycast.is_colliding():
		#return false
	
	for light_check_raycast in raycast_array:
		raycast_to_light_source(light_check_raycast, player_position)
		if light_check_raycast.is_colliding():
			GameData.light_blocking_object = light_raycast.get_collider()
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

