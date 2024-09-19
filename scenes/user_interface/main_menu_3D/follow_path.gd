extends Node3D
@onready var mesh: MeshInstance3D = $CollisionShape3D/MeshInstance3D
@export var emotion_state: EmotionState
func _ready():
	mesh.get_active_material(0).albedo_color = emotion_state.color
	mesh.get_active_material(0).emission = emotion_state.color
	
func _physics_process(delta):
	const move_speed := 80
	$"..".progress += move_speed * delta
