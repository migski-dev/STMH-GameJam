extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/stages/stage_one/levels/stage_1_level_6.tscn")


func _on_controls_pressed():
	get_tree().change_scene_to_file("res://scenes/user_interface/main_menu/options_menu/options_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
