extends CSGBox3D

class_name interactable_test

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interactable_focused(interactor):
	print("Object ID: ", self.get_instance_id(), " is in focus")


func _on_interactable_interacted(interactor):
	print("Interacted with object ID: ", self.get_instance_id())


func _on_interactable_unfocused(interactor):
	print("Object ID: ", self.get_instance_id(), " is out of focus")
