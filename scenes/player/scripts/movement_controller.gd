extends Node

@export var player: CharacterBody3D
@export var mesh_root: Node3D
@export var rotation_speed: float = 8

@export var jump_height: float = 0.05
@export var jump_duration: float = 0.016

var direction: Vector3
var velocity: Vector3
var acceleration: float 
var speed: float
var cam_rotation : float = 0

var is_jumping: bool = false
var jump_velocity: float
var jump_gravity: float

func _ready():
	jump_velocity = 2 * jump_height / jump_duration
	jump_gravity = jump_velocity / jump_duration

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") and not is_jumping:
		is_jumping = true
		player.velocity.y = jump_velocity

	if is_jumping:
		velocity.y = player.velocity.y - (jump_gravity * delta)
	else:
		velocity.y = player.velocity.y  # Normal gravity or other vertical forces
	
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z
	
	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.move_and_slide()
	
	var target_rotation = atan2(direction.x, direction.z) - player.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)
	
	if player.is_on_floor():
		is_jumping = false

func _on_set_movement_state(_movement_state: MovementState):
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration
	
	
func _on_set_movement_direction(_movement_direction: Vector3):
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)
	
func _on_set_cam_rotation(_cam_rotation: float):
	cam_rotation = _cam_rotation
