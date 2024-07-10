extends Node3D

var player: Player
var MOVE_SPEED: float = 0.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var possession_camera: Camera3D = $Camera3D
var animation_length: float

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group('player')
	var animation: Animation = animation_player.get_animation("door|door|close|Animation Base Layer")
	animation.loop_mode = Animation.LOOP_NONE
	animation_player.play('door|door|close|Animation Base Layer', -1, 0.0, false)
	animation_length = animation_player.current_animation_length

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not player.possession_locked):
		return
		
	if Input.is_action_pressed("right"):
		if(animation_player.current_animation_position < animation_length):
			animation_player.play('door|door|close|Animation Base Layer', -1, 1.0, false)
	elif Input.is_action_pressed("left"):
		if(animation_player.current_animation_position > 0):
			animation_player.play('door|door|close|Animation Base Layer', -1, -1.0, false)
	else:
		animation_player.pause()
	
	
func _on_interacted():
	pass

#func _input(event):
	#if event.is_action("movement") and player.possession_locked:
		#MOVE_SPEED = Input.get_action_strength("left") - Input.get_action_strength("right")
