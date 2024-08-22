extends Node3D

@onready var emotion_key: EmotionState = load("res://resources/emotion_states/anxiety.tres")

@export var directional_light: Node3D
@onready var player: Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var possession_camera: Camera3D = $CamRoot/CamYaw/CamPitch/SpringArm3D/Camera3D
@onready var raycast: RayCast3D = $RayCast3D
@onready var target: Marker3D = $Marker3D

var MOVE_SPEED: float = 0.0
var animation_length: float
var casted_shadow_position: Vector3

var min_rotation: float = 0.0
var max_rotation: float = 180

var unlocked: bool = false

func _ready():
	player = get_tree().get_first_node_in_group('player')
	#var animation: Animation = animation_player.get_animation("door|door|close|Animation Base Layer")
	#animation.loop_mode = Animation.LOOP_NONE
	animation_player.play('Take 01', -1, 0.0, false)
	animation_length = animation_player.current_animation_length

func _physics_process(delta):
	if not is_controllable():
		return
	
	if Input.is_action_pressed("right"):
		if(animation_player.current_animation_position < animation_length):
			animation_player.play('Take 01', -1, 1.5, false)
			var current_basis = directional_light.transform.basis
			var current_quat = Quaternion(current_basis)
			
			var rotation_angle = deg_to_rad(1)
			var rotation_quat = Quaternion(Vector3(0,1,0), rotation_angle)
			
			var global_transform = Transform3D(current_basis)
			var rotation_basis = Basis(rotation_quat)
			
			var target_basis = current_basis * rotation_basis
			var target_quat = target_basis.get_rotation_quaternion()
			
			var lerped_quat = current_quat.slerp(target_quat, 0.5)
			directional_light.transform.basis = Basis(lerped_quat)
			
	elif Input.is_action_pressed("left"):
		if(animation_player.current_animation_position > 0):
			animation_player.play('Take 01', -1, -1.5, false)
			
			var current_basis = directional_light.transform.basis
			var current_quat = Quaternion(current_basis)
			
			var rotation_angle = deg_to_rad(-1)
			var rotation_quat = Quaternion(Vector3(0,1,0), rotation_angle)
			
			var rotation_basis = Basis(rotation_quat)
			
			var target_basis = current_basis * rotation_basis
			var target_quat = target_basis.get_rotation_quaternion()
			
			var lerped_quat = current_quat.slerp(target_quat, 0.5)
			directional_light.transform.basis = Basis(lerped_quat)
			
	elif Input.is_action_pressed("interact"):
		if(EventManager.possession_mode):
			EventManager.on_possession_exit_start.emit()
			EventManager.possession_mode = false
			get_tree().get_first_node_in_group('levels').add_child(player)
			player = get_tree().get_first_node_in_group('player')
			reposition_player_to_shadow()
			player.movement_locked = true
			player.global_transform.origin = casted_shadow_position
			CameraTransition.transition_camera(get_viewport().get_camera_3d(), player.player_camera)
	else:
		animation_player.pause()
		
func is_controllable() -> bool: 
	if(EventManager.light_blocking_object == null):
		return false
	if not (EventManager.light_blocking_object == self or EventManager.light_blocking_object.owner == self):
		return false
	if(not EventManager.possession_mode):
		return false
	if(CameraTransition.transitioning):
		return false
	return true
		
func reposition_player_to_shadow():
	get_shadow_position()
	player.global_transform.origin = casted_shadow_position
	
func get_shadow_position():
	var light_dir: Vector3 = EventManager.current_light.global_transform.basis.z.normalized() # Direction of Light
	var light_pos: Vector3 = target.global_transform.origin + light_dir * 1000 # Large Distance in Direction of Light
	raycast.global_transform.origin = target.global_transform.origin 
	raycast.target_position = target.global_transform.origin - light_pos 
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		casted_shadow_position = raycast.get_collision_point()
	else:
		casted_shadow_position = global_transform.origin
		#return player.global_transform.origin  # Fallback if no collision detected


