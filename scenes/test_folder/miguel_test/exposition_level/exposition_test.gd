extends Node3D

@onready var light = $DirectionalLight3D
@export var player: CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	GameData.current_light = light 
	print(str(light.get_instance_id()))
