extends Node3D
@onready var spotlight = $Props/Spotlight
@onready var dir_light = $Environment/DirectionalLight3D

func _ready():
	GameData.current_light = dir_light
	#GameData.current_light = spotlight
