extends Node3D

signal on_object_move(progress: float)
signal on_possession_end(return_position: Vector3)

@export var player: Player
@export var path: PathFollow3D
@onready var possession_ui: Node2D = $PossessionProgress
var previous_position: Vector3
var current_velocity: Vector3
var move: bool = true
var MOVE_SPEED: float = 0.0
@onready var possession_camera = $Camera3D
@onready var static_body = $StaticBody3D
@onready var target = $Marker3D
@onready var raycast = $RayCast3D
var casted_shadow_position: Vector3
var is_player_able_to_exit: bool = true
var exclusion_array: Array = [] 
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	possession_ui.visible = false
	CameraTransition.possession_enter_complete.connect(on_possession_enter)
	CameraTransition.possession_exit_complete.connect(on_possession_exit)
	previous_position = global_transform.origin
	for interactable in get_tree().get_nodes_in_group('interactable_group'):
		if interactable.is_class('CollisionObject3D'):
			print(interactable.get_class())
			exclusion_array.push_back(interactable.get_rid())
	#path.progress_ratio = 0.1

func _physics_process(delta: float):
	if not EventManager.possession_mode:
		possession_ui.hide_canvas_layer()
		
	get_shadow_position()
	
	if not possession_check():
		return 
	if Input.is_action_pressed("movement"):
		MOVE_SPEED = Input.get_action_strength("left") - Input.get_action_strength("right")
		move_object_on_path(delta)
	elif Input.is_action_pressed("interact"):
		if not is_player_able_to_exit:
			return
		MOVE_SPEED = 0
		EventManager.possession_mode = false
		EventManager.on_player_exit_possession(casted_shadow_position)
	else:
		MOVE_SPEED = 0
		get_shadow_position()
	


func move_object_on_path(delta: float):
	var progress = clamp(path.progress_ratio + MOVE_SPEED/3 * delta, 0, 1)
	path.progress_ratio = progress
	on_object_move.emit(path.progress_ratio)
	


func possession_check() -> bool:
	if (not EventManager.possession_mode):
		return false
	if CameraTransition.transitioning:
		return false
	if not (EventManager.light_blocking_object == static_body or EventManager.light_blocking_object.owner == self):
		return false
		
	return true


func get_shadow_position() -> void:
	var ray_origin = target.global_transform.origin
	var light_dir = - EventManager.current_light.global_transform.basis.z.normalized()
	var ray_length = 1000.0
	var ray_end = ray_origin + light_dir*ray_length
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	# For each object in interactable object group, add to array and exclude
	query.exclude = exclusion_array
	var raycast_result = space_state.intersect_ray(query)
	
	if(raycast_result):
		var collider = raycast_result
		is_player_able_to_exit = true
		casted_shadow_position = raycast_result.position
	else:
		is_player_able_to_exit = false
		
func on_possession_enter() -> void:
	if(EventManager.light_blocking_object == self or EventManager.light_blocking_object == static_body):
		animation_player.play('possession', -1, 2.0, false)

func on_possession_exit() -> void:
	if(EventManager.light_blocking_object == self or EventManager.light_blocking_object == static_body):
		animation_player.play('possession', -1, -2.0, true)
