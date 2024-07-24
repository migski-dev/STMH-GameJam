extends CharacterBody3D

@export var player: CharacterBody3D

func _ready():
	self.global_transform.origin = player.global_transform.origin
	
func _process(delta):
	if not EventManager.possession_mode:
		var emotion_transform = self.global_transform.origin
		var player_transform = player.global_transform.origin
		var distance = player_transform - emotion_transform
		
		if distance.length() > 1:
			self.global_transform.origin = emotion_transform + distance / 100	
