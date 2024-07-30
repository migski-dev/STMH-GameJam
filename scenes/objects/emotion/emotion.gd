extends CharacterBody3D
class_name Emotion

@export var player: CharacterBody3D
var follow_player: bool

#func _ready():
	#self.global_transform.origin = player.global_transform.origin
	
func _process(delta):
	if not EventManager.possession_mode and follow_player:
		var emotion_transform: Vector3 = self.global_transform.origin
		var player_transform: Vector3 = player.global_transform.origin
		var distance: Vector3 = player_transform - emotion_transform
		
		if distance.length() > 1:
			self.global_transform.origin = emotion_transform + distance / 100	


func _on_snap_area_body_entered(body):
	player.has_emotion_key = true
	follow_player = true
