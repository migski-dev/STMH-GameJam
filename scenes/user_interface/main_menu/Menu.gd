extends Control

func _ready(): 
	$MarginContainer/VBoxContainer/Play.grab_focus()
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")


func _on_controls_pressed():
	get_tree().change_scene_to_file("res://scenes/user_interface/main_menu/options_menu/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
