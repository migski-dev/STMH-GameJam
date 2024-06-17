extends Node

@export var player: CharacterBody3D
@export var mesh_root: Node3D
@export var light_raycast: RayCast3D
@export var rotation_speed: float = 8
@export var light_detection: Node3D
@export var target_position_bias: float = 2.5

var direction: Vector3
var velocity: Vector3
var acceleration: float 
var speed: float
var cam_rotation : float = 0
var target_position : Vector3


func _physics_process(delta):
	#Set Player Velocity	
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z
	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	
	#Check if player will walk into light
	target_position = player.global_transform.origin + player.velocity * delta * target_position_bias
	if not light_detection.check_valid_move(target_position):
		player.global_transform.origin -= velocity.normalized() * 0.5 # Move player slightly away
		player.velocity = -player.velocity * .1 # Add negative velocity
	
	player.move_and_slide()
		
	var target_rotation = atan2(direction.x, direction.z) - player.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)


func _on_set_movement_state(_movement_state: MovementState):
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration
	
func _on_set_movement_direction(_movement_direction: Vector3):
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)
	
func _on_set_cam_rotation(_cam_rotation: float):
	cam_rotation = _cam_rotation
