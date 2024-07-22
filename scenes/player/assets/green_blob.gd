extends Node3D

@onready var body_mesh = $RootNode/CharacterArmature/Skeleton3D/Green_Blob as MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player = get_tree().get_first_node_in_group('player')

func _ready():
	# Bad Practice that I had to do because I didn't do import settings correctly
	var animation: Animation = animation_player.get_animation("CharacterArmature|Idle -loop")
	animation.loop_mode = Animation.LOOP_LINEAR
	animation = animation_player.get_animation("CharacterArmature|Walk -loop")
	animation.loop_mode = Animation.LOOP_LINEAR
	animation = animation_player.get_animation("CharacterArmature|Dance")
	animation.loop_mode = Animation.LOOP_LINEAR
	
	
#func _physics_process(delta):
	## Syncs the color of the body to the averaged surface color
	#
	#if(player.is_on_floor()):
		##body_mesh.get_active_material(0).albedo_color = player.get_color_rect_color()
		#body_mesh.get_active_material(0).albedo_color = Color('#FF0000') #red
	#else:	
		#body_mesh.get_active_material(0).albedo_color = Color('#0000FF') #blue
