extends Node3D
@onready var light_detection := $DirectionalLight3D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.current_light = light_detection
