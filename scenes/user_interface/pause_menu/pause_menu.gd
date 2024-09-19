extends Control

@onready var level: Node = get_parent()


func _on_resume_pressed():
	level.pause_game()


func _on_quit_pressed():
	get_tree().quit()
