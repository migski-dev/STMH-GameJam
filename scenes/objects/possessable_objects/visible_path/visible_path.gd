extends CSGPolygon3D

@onready var anim_player: AnimationPlayer =  $AnimationPlayer

func play_glow() -> void:
	anim_player.play("interact_glow", -1, 1, false)

func end_glow() -> void: 
	anim_player.play("RESET", -1, 1, false)
