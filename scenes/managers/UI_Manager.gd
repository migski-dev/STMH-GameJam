extends Node
class_name ui

@onready var pause_menu = $PauseMenu
@onready var is_game_running = false

func _ready():
	pause_menu.hide()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause_game()

func pause_game():
	if is_game_running:
		pause_menu.hide()
		Engine.time_scale = 1
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else: 
		pause_menu.show()
		Engine.time_scale = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	is_game_running = !is_game_running
