extends CharacterBody3D
class_name Player

# Movement State Signals
signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)
signal on_player_enter_new_shadow()

#Jumping Stuff
signal press_jump(_jump_state: JumpState)
@export var jump_states: Dictionary
@export var default_jump: JumpState
@export var jump_buffer_time: float = 0.1
@onready var jump_available:bool = true
@onready var jump_buffer:bool = false
var pre_jump_position: Vector3
var fall_gravity : float = 45
var jump_gravity: float = fall_gravity

# Movement State Variables
@export var movement_states: Dictionary
var movement_direction: Vector3 
var is_in_shadow : bool = true
var movement_locked: bool = false
var moving_shadow_bias: Vector3 = Vector3.ZERO

@onready var player_camera: Camera3D = $CamRoot/CamYaw/CamPitch/SpringArm3D/Camera3D
var possession_locked: bool = false

var current_emotion_orbs: Array[Emotion]
var current_emotion: EmotionState
var in_dialogue: bool = false

func _ready() -> void:
	# Set Default movement state
	set_movement_state.emit(movement_states["idle"])
	# Capture mouse cursor for mouse look
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventManager.on_player_acquire_emotion.connect(_on_player_acquire_emotion)
	CameraTransition.possession_exit_complete.connect(_on_possession_exit_complete)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _physics_process(_delta: float) -> void:
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)

func _input(event: InputEvent) -> void:
	if movement_locked:
		return

	possession_input_handler(event)
	
	if not EventManager.possession_mode and not movement_locked: 
		movement_input_handler(event)
		jump_input_handler(event)
		
func check_if_player_has_emotion(emotion: EmotionState) -> bool:
	var emotion_name = emotion.emotion_name
	for emotion_orb in current_emotion_orbs:
		if emotion_name == emotion_orb.emotion_state.emotion_name:
			return true
	return false
	
	
func possession_input_handler(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_on_floor() and EventManager.is_light_blocking_object_interactable() and not CameraTransition.transitioning:
		if not EventManager.possession_mode:
			if (not current_emotion_orbs.size() == 0) and check_if_player_has_emotion(EventManager.light_blocking_object.owner.required_emotion):
				EventManager.on_possession_enter_start.emit()
				EventManager.possession_mode = true
				CameraTransition.transition_camera(player_camera, EventManager.light_blocking_object.get_owner().possession_camera, 1.0)
			else:
				if(not in_dialogue):
					in_dialogue = true
					var path = "player/missing_emotion.dialogue"
					DialogueManager.show_dialogue_balloon(load("res://assets/dialogue/" + path), "start")
					await DialogueManager.dialogue_ended
				
		#else:
			#CameraTransition.transition_camera(EventManager.light_blocking_object.get_owner().possession_camera, player_camera, 1.0)
		

func movement_input_handler(event: InputEvent) -> void:
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
		movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("back")
			
		if is_movement_ongoing():
			if Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("forward") || Input.is_action_pressed("back") :
				set_movement_state.emit(movement_states['walk'])
		else:
			set_movement_state.emit(movement_states['idle'])

func jump_input_handler(event: InputEvent) -> void:
	if in_dialogue:
		return
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
	press_jump.emit(jump_states["default_jump"])
	jump_available = false

func on_jump_buffer_timeout()->void:
	jump_buffer = false

func is_movement_ongoing():
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
	
func _on_possession_exit_complete()->void:
	movement_locked = false

# if player has no emotion state, ask player if they would like to process the emotion
# if player already has an emotion state, ask player if they would like to swap current emotion 
# on player confirm, set the current emotion state of player to the passed emotion from signal
  
func _on_player_acquire_emotion(emotion: EmotionState)->void:
	#play dialogue "process emotion?"
	#camera shake on confirm + color tinted vision (seeing red)
	current_emotion = emotion
	print('hi')

func _on_dialogue_ended(resource) -> void:
	in_dialogue = false

