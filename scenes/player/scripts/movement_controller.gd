extends Node

@export var player: Player
@export var mesh_root: Node3D
@export var light_raycast: RayCast3D
@export var rotation_speed: float = 8
@export var fall_gravity : float = 30
@export var light_detection: Node3D
@export var target_position_bias: float = 5
@export var jump_gravity: float = fall_gravity
@export var jump_state_temp: JumpState
@export var coyote_time: float = 0.5

var direction: Vector3
var velocity: Vector3
var target_velocity: Vector3
var acceleration: float 
var speed: float
var cam_rotation : float = 0
@onready var just_landed: bool = false
var lock_time: float = 1.0

var lock_time: float = 1.0


func _physics_process(delta):
	set_horizontal_velocity()
	set_vertical_velocity(delta)
	move_player(delta)
	set_rotations(delta)


func set_horizontal_velocity() -> void:
	if(GameData.light_blocking_object != null and GameData.light_blocking_object.is_in_group('moving_objects') and player.is_on_floor()):
		velocity.x = speed * direction.normalized().x + player.moving_shadow_bias.x
		velocity.z = speed * direction.normalized().z + player.moving_shadow_bias.z
	else:
		velocity.x = speed * direction.normalized().x
		velocity.z = speed * direction.normalized().z


func set_vertical_velocity(delta) -> void:
	if not player.is_on_floor():
		if player.jump_available:
			get_tree().create_timer(coyote_time).timeout.connect(coyote_timeout)
		
		if velocity.y >= 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
	else:
		player.jump_available = true
		if player.jump_buffer:
			player.jump()
			player.jump_buffer = false


func move_player(delta) -> void:
	if(player.movement_locked):
		return
	player.velocity = player.velocity.lerp(velocity, acceleration * delta) # Sets Intended velocity
	
	if player.is_on_floor():
		if check_if_heading_into_light(delta):
			if GameData.is_light_blocking_object_moving():
				player.global_transform.origin -= direction.normalized() * 0.08 * player.moving_shadow_bias.length()
				player.velocity = -player.velocity * .1 * player.moving_shadow_bias.length()
			else:
				player.global_transform.origin -= direction.normalized() * 0.02 
				player.velocity = -player.velocity * .1
			 # Add negative velocity
			
	# Added logic to check if player landed in the light 
	# Added logic to check if player landed in the light 
	var was_in_air: bool = not player.is_on_floor()
	player.move_and_slide()
	
	just_landed = player.is_on_floor() and was_in_air
	if just_landed and not player.is_in_shadow:
		player.movement_locked = true
		velocity = Vector3.ZERO
		player.velocity = Vector3.ZERO
		get_tree().create_timer(lock_time).timeout.connect(_on_lock_timer_end)

func coyote_timeout() -> void:
	player.jump_available = false


func check_if_heading_into_light(delta) -> bool:
	var target_position : Vector3 = player.global_transform.origin + player.velocity * delta * (target_position_bias)   
	if GameData.is_light_blocking_object_moving() :
		target_position = player.global_transform.origin + Vector3(player.velocity.x - player.moving_shadow_bias.x, player.velocity.y, player.velocity.z - player.moving_shadow_bias.z) * delta * target_position_bias
	target_position.y += .1
	return not light_detection.check_valid_move(target_position)
			
			
func set_rotations(delta) -> void:
	var target_rotation = atan2(direction.x, direction.z) - player.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)


func _on_player_press_jump(_jump_state: JumpState) -> void:
	velocity.y = 2 * _jump_state.jump_height / _jump_state.apex_duration
	jump_gravity = velocity.y / _jump_state.apex_duration


func _on_set_movement_state(_movement_state: MovementState) -> void:
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration


func _on_set_movement_direction(_movement_direction: Vector3) -> void:
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)


func _on_set_cam_rotation(_cam_rotation: float) -> void:
	cam_rotation = _cam_rotation


func _on_lock_timer_end() -> void:
	player.global_transform.origin = player.pre_jump_position
	player.movement_locked = false

