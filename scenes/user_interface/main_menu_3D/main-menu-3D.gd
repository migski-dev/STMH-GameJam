extends Node3D

@onready var start_scene: PackedScene = preload("res://scenes/stages/stage_one/levels/stage_1_level_6.tscn")
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_play_pressed():
	var start_level: Node3D = start_scene.instantiate()
	get_tree().root.add_child(start_level)
	get_tree().current_scene = start_level
	get_tree().root.remove_child(self)
	
	#get_tree().change_scene_to_packed(start_level)
	#get_tree().change_scene_to_file("res://scenes/stages/stage_one/levels/stage_1_level_6.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/user_interface/main_menu/options_menu/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

