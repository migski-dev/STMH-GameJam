extends CharacterBody3D

# Movement State Signals
signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

# Movement State Variables
@export var movement_states: Dictionary
var movement_direction: Vector3 

# Light Detection Nodes
@onready var sub_viewport := $SubViewport
@onready var light_detection := $SubViewport/LightDetection
@onready var texture_rect := $TextureRect
@onready var color_rect := $ColorRect
@onready var light_level := $LightLevel
@onready var mesh := $MeshRoot

var is_in_shadow : bool = true


func _ready() -> void:
	# Set Default movement state
	set_movement_state.emit(movement_states["idle"])
	# Capture mouse cursor for mouse look
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Make SubViewport render lighting only
	sub_viewport.debug_draw = 2

func _physics_process(delta: float) -> void:	
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)


func _process(delta: float) -> void:
	# Light detection
	light_detection.global_position = global_position # Make light detection follow the player
	var texture = sub_viewport.get_texture() # Get the ViewportTexture from the SubViewport
	texture_rect.texture = texture # Display this texture on the TextureRect
	var color = get_average_color(texture) # Get the average color of the ViewportTexture
	color_rect.color = color # Display the average color on the ColorRect
	light_level.value = color.get_luminance() # Use the average color's brighness as the light level value
	light_level.tint_progress.a = color.get_luminance() # Also tint the progress texture with the above
	

func _input(event: InputEvent) -> void:
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		movement_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
		
		if is_movement_ongoing():
			if Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("forward") || Input.is_action_pressed("back") :
				set_movement_state.emit(movement_states['walk'])
		else:
			set_movement_state.emit(movement_states['idle'])


func is_movement_ongoing():
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0

func get_average_color(texture: ViewportTexture) -> Color:
	var image = texture.get_image() # Get the Image of the input texture
	image.resize(1, 1, Image.INTERPOLATE_LANCZOS) # Resize the image to one pixel
	return image.get_pixel(0, 0) # Read the color of that pixel
	
func get_color_rect_color():
	return color_rect.color

func _on_ray_cast_root_player_in_light():
	pass
