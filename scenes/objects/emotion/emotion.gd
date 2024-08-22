extends CharacterBody3D
class_name Emotion

@export var emotion_state: EmotionState
@export var player: CharacterBody3D
@onready var mesh: MeshInstance3D = $CollisionShape3D/MeshInstance3D
var follow_player: bool

func _ready():
	mesh.get_active_material(0).albedo_color = emotion_state.color
	mesh.get_active_material(0).emission = emotion_state.color

	
func _process(delta):
	if not EventManager.possession_mode and follow_player:
		var emotion_transform: Vector3 = self.global_transform.origin
		var player_transform: Vector3 = player.global_transform.origin
		var distance: Vector3 = player_transform - emotion_transform
		
		if distance.length() > 1:
			self.global_transform.origin = emotion_transform + distance / 100	


func _on_snap_area_body_entered(body):
	player.current_emotion = emotion_state
	follow_player = true
	
func random_color_fluctuate() -> void:
	mesh.get_active_material(0).emission = mesh.get_active_material(0).albedo_color
	var dest_color = emotion_state.color_fluctuate_array.pick_random()
	var speed = .5
	mesh.get_active_material(0).emission = mesh.get_active_material(0).emission.lerp(dest_color, speed)
	
func reset_color() -> void: 
	var dest_color = emotion_state.color
	var speed = .5
	mesh.get_active_material(0).emission = mesh.get_active_material(0).emission.lerp(dest_color, speed)
