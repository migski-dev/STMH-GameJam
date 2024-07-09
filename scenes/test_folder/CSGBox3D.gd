extends CSGBox3D

class_name interactable_test

@onready var audio_player = $AudioStreamPlayer

func _on_interacted():
	print("hi")
	audio_player.play()
	await audio_player.finished
