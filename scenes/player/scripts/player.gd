extends CharacterBody3D
class_name Player
# Movement State Signals
signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

#Jumping Stuff
signal press_jump(_jump_state: JumpState)
@export var jump_states: Dictionary
@export var default_jump: JumpState
var pre_jump_position: Vector3


@export var jump_buffer_time: float = 0.3
@onready var jump_available:bool = true
@onready var jump_buffer:bool = false
var fall_gravity : float = 45
var jump_gravity: float = fall_gravity

@onready var audio_player = $AudioStreamPlayer

# Movement State Variables
@export var movement_states: Dictionary
var movement_direction: Vector3 

var is_in_shadow : bool = true
var movement_locked: bool = false
var moving_shadow_bias: Vector3 = Vector3.ZERO

func _ready() -> void:
	# Set Default movement state
	set_movement_state.emit(movement_states["idle"])
	# Capture mouse cursor for mouse look
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _physics_process(delta: float) -> void:
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)

func _input(event: InputEvent) -> void:
	if movement_locked:
		return
	movement_input_handler(event)
	jump_input_handler(event)
	
	if event.is_action_pressed("interact"):
		GameData.on_player_interact()


func movement_input_handler(event: InputEvent) -> void:
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		movement_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
			
			
		if is_movement_ongoing():
			if Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("forward") || Input.is_action_pressed("back") :
				set_movement_state.emit(movement_states['walk'])
		else:
			set_movement_state.emit(movement_states['idle'])

func jump_input_handler(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if is_in_shadow:
			pre_jump_position = self.global_transform.origin
				
		if (is_on_floor() or jump_buffer) and jump_available:
			jump()
		else:
			if not is_on_floor():
				jump_buffer = true
				get_tree().create_timer(jump_buffer_time).timeout.connect(on_jump_buffer_timeout)
			jump_available = true
		
		
func jump()->void:
	press_jump.emit(default_jump)
	audio_player.play()
	jump_available = false


func on_jump_buffer_timeout()->void:
	jump_buffer = false

func is_movement_ongoing():
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0


func get_average_color(texture: ViewportTexture) -> Color:
	var image = texture.get_image() # Get the Image of the input texture
	image.resize(1, 1, Image.INTERPOLATE_LANCZOS) # Resize the image to one pixel
	return image.get_pixel(0, 0) # Read the color of that pixel
	
