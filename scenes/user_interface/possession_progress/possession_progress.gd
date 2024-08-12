extends Node2D

@onready var progress_bar: ProgressBar = $CanvasLayer/MarginContainer/VBoxContainer/ProgressBar
var progress: float = 0.0
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready():
	canvas_layer.hide()

func _on_moveable_block_on_object_move(path_progress) -> void:
	canvas_layer.show()
	progress = path_progress
	progress_bar.value = progress
	print(progress_bar.value)

func hide_canvas_layer():
	canvas_layer.hide()
