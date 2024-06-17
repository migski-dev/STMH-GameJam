extends Node3D
@onready var spotlight = $Props/Spotlight
@onready var dir_light = $Environment/DirectionalLight3D
@onready var player: CharacterBody3D = $Player

func _ready():
	player.apply_floor_snap()
	GameData.current_light = dir_light
	#GameData.current_light = spotlight
