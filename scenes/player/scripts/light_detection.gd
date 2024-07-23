extends Node3D

signal on_player_heading_to_light()
signal on_player_land_in_light()
signal on_player_enter_new_shadow()
#signal on_player_enter_moving_shadow()

@export var player: Player 
@onready var target_raycast: RayCast3D = $TargetRaycast


var light_blocked_flag: bool = false 
@export var player_raycast: RayCast3D 

var just_landed = false
@export var target_position_bias: float = 20

var play_mode = false

func _ready():
	var level = get_tree().get_first_node_in_group('levels')
	if level:
		play_mode = true 

func _physics_process(delta):
	if(not play_mode):
		return
	
	# Check if player is currently in the light - might not be needed
	if is_in_shadow():
		player.is_in_shadow = true
	else: 
		player.is_in_shadow = false
	
	# Check if player is exiting shadow
	if player.is_on_floor() and check_if_heading_into_light(delta) and not player.movement_locked:
		on_player_heading_to_light.emit()
				
func check_if_heading_into_light(delta) -> bool:
	var target_position : Vector3 = player.global_transform.origin + player.velocity * delta * (target_position_bias)   
	if EventManager.is_light_blocking_object_moving() :
		target_position = player.global_transform.origin + Vector3(player.velocity.x - player.moving_shadow_bias.x, player.velocity.y, player.velocity.z - player.moving_shadow_bias.z) * delta * target_position_bias
	target_position.y += .1
	
	target_raycast.global_transform.origin = target_position 
	raycast_to_light_source(target_raycast, target_raycast.position)
	
	if target_raycast.is_colliding():
		return false
	else:
		return true

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
		if not(colliding_object == EventManager.light_blocking_object):
			on_player_enter_new_shadow.emit()
			EventManager.light_blocking_object = colliding_object
		#EventManager.local_collision_position = colliding_position
		
	
	return player_in_shadow
		
		

func raycast_to_light_source(raycast: RayCast3D, start_position: Vector3) -> void:
	var light_dir: Vector3 = EventManager.current_light.global_transform.basis.z.normalized() # Direction of Light
	var light_pos: Vector3 = start_position - light_dir * 1000 # Large Distance in Direction of Light
	
	raycast.target_position = start_position - light_pos
	raycast.add_exception(player)

	raycast.force_raycast_update()



func _on_lock_timer_end() -> void:
	if(player.pre_jump_position):
		player.global_transform.origin = player.pre_jump_position
		
	player.movement_locked = false


func _on_player_landed():
	if not is_in_shadow():
		on_player_land_in_light.emit()
		player.set_movement_state.emit(player.movement_states["idle"])
		
