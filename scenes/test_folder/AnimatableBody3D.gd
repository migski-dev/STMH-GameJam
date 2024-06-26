extends AnimatableBody3D

@export var player: Player
@export var path: PathFollow3D
@onready var raycast: RayCast3D = $RayCast3D
var previous_position: Vector3
var current_velocity: Vector3
var move: bool = true
var MOVE_SPEED: float = 1.0

func _ready():
	previous_position = global_transform.origin
	
func _physics_process(delta):
	
	path.progress += MOVE_SPEED * delta
	
	# Calculate current velocity
	var current_position = global_transform.origin
	current_velocity = (current_position - previous_position) / delta
	previous_position = current_position
	
	if(GameData.light_blocking_object == self):
		add_velocity_bias()
	else:
		reset_velocity_bias()
		
func add_velocity_bias():
	if(player.is_on_floor()):
		player.moving_shadow_bias = current_velocity
		

func reset_velocity_bias():
	player.moving_shadow_bias = Vector3.ZERO
	
func _on_interacted():
	if(move):
		MOVE_SPEED = 0.0
		move = false
	else:
		MOVE_SPEED = 1.0
		move = true
