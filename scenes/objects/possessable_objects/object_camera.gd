extends Node3D

signal set_cam_rotation(_cam_rotation: float)

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera = $CamYaw/CamPitch/SpringArm3D/Camera3D


var yaw: float = 0
var pitch: float = 0

var yaw_sens : float = 0.07
var pitch_sens : float = 0.07

var yaw_accel : float = 15
var pitch_accel : float = 15

#var pitch_max: float = -5
var pitch_max: float =  35
var pitch_min: float = -75

var tween: Tween


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	pass
	#if event is InputEventMouseMotion: 
		#yaw += -event.relative.x * yaw_sens
		#pitch += -event.relative.y * pitch_sens
	

func _physics_process(delta):
	pitch = clamp(pitch, pitch_min, pitch_max)
	
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_accel * delta)
	pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_accel * delta)
	
	set_cam_rotation.emit(yaw_node.rotation.y)


func _on_set_movement_state(_movement_state: MovementState):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(camera, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
