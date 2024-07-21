extends Node3D
@onready var spotlight = $Props/Spotlight
@onready var dir_light = $Environment/DirectionalLight3D
@onready var player: CharacterBody3D = $Player

func _ready():
	player.apply_floor_snap()
	EventManager.current_light = dir_light
	#EventManager.current_light = spotlight
