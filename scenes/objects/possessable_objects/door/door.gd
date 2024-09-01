extends Node3D

@onready var player: Player
var MOVE_SPEED: float = 0.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var possession_camera: Camera3D = $CamRoot/CamYaw/CamPitch/SpringArm3D/Camera3D
@onready var raycast: RayCast3D = $RayCast3D
@onready var area3d: Area3D = $"RootNode/door-rotate-square-c/Area3D"
@onready var collider: StaticBody3D = $"RootNode/door-rotate-square-c/door/StaticBody3D"

@onready var collision: CollisionShape3D = $"RootNode/door-rotate-square-c/door/StaticBody3D/CollisionShape3D"
@onready var target: Marker3D = $"RootNode/door-rotate-square-c/Marker3D"
var animation_length: float
var casted_shadow_position: Vector3

func _ready():
	player = get_tree().get_first_node_in_group('player')
	var animation: Animation = animation_player.get_animation("door|door|close|Animation Base Layer")
	animation.loop_mode = Animation.LOOP_NONE
	animation_player.play('door|door|close|Animation Base Layer', -1, 0.0, false)
	animation_length = animation_player.current_animation_length
	area3d.body_entered.connect(_on_player_finish)

func _physics_process(delta):
	if(EventManager.light_blocking_object == null):
		return
	if not (EventManager.light_blocking_object == self or EventManager.light_blocking_object.owner == self):
		return
	if(not EventManager.possession_mode):
		return
	get_shadow_position()
	
	if(not CameraTransition.transitioning):
		if Input.is_action_pressed("left"):
			if(animation_player.current_animation_position < animation_length):
				get_shadow_position()
				animation_player.play('door|door|close|Animation Base Layer', 1, 1.0, false)
		elif Input.is_action_pressed("right"):
			if(animation_player.current_animation_position > 0):
				get_shadow_position()
				animation_player.play_backwards('door|door|close|Animation Base Layer', -1)
		elif Input.is_action_pressed("interact"):
			if(EventManager.possession_mode):
				EventManager.possession_mode = false
				get_tree().get_first_node_in_group('levels').add_child(player)
				player = get_tree().get_first_node_in_group('player')
				player.movement_locked = true
				player.global_transform.origin = casted_shadow_position
				CameraTransition.transition_camera(get_viewport().get_camera_3d(), player.player_camera)
				
		else:
			animation_player.pause()
		

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
		casted_shadow_position = raycast.get_collision_point()
	else:
		casted_shadow_position = player.global_transform.origin
		#return player.global_transform.origin  # Fallback if no collision detected

func _on_player_finish(body: Node3D):
#	possession end design the architecture
	print('yay')

