extends CSGPolygon3D

@onready var anim_player: AnimationPlayer =  $AnimationPlayer
@onready var mesh1: MeshInstance3D = $_MeshInstance3D_23362
@onready var mesh2: MeshInstance3D = $_MeshInstance3D_23362/_MeshInstance3D_13528

func _ready() -> void: 
	mesh1.visible = false
	mesh2.visible = false
	
func play_glow() -> void:
	mesh1.visible = true
	mesh2.visible = true
	anim_player.play("interact_glow", -1, 1, false)

func end_glow() -> void: 
	mesh1.visible = false
	mesh2.visible = false
	anim_player.play("RESET", -1, 1, false)
