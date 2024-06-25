extends Area3D

class_name Interactor

var controller: Node3D

func interact(interactable: Interactable) -> void:
	interactable.interacted.emit(self)
