extends Node3D

signal player_in_light()
signal on_target_in_light()
#signal on_player_enter_moving_shadow()

@export var player: Player 
@onready var target_raycast: RayCast3D = $TargetRaycast

var light_blocked_flag: bool = false 
@export var player_raycast: RayCast3D 

func _physics_process(delta):
	if is_in_shadow():
		player.is_in_shadow = true
		
	else: 
		player.is_in_shadow = false

# Returns false if and only if all of the raycasts are in the light (all do not collide)
func is_in_shadow() -> bool:
	var raycast_array = get_tree().get_nodes_in_group('light_raycasts') as Array[RayCast3D]
	var player_position: Vector3 = player.global_transform.origin
	var colliding_object = null
	var colliding_position: Vector3
	var all_collide_with_same: bool = true
	var player_in_shadow:bool = false
	
	for light_check_raycast in raycast_array:
		raycast_to_light_source(light_check_raycast, player_position)
		
		if light_check_raycast.is_colliding():
			player_in_shadow = true
			
			var current_object = light_check_raycast.get_collider()
			colliding_position = current_object.to_local(light_check_raycast.get_collision_point())
			
			if colliding_object == null: 
				colliding_object = current_object
			elif colliding_object != current_object:
				all_collide_with_same = false
		
		else:
			all_collide_with_same = false
	
	if all_collide_with_same:
		GameData.light_blocking_object = colliding_object
		GameData.local_collision_position = colliding_position
		
	
	return player_in_shadow
		
		

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

