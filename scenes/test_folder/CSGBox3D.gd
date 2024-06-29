extends CSGBox3D

class_name interactable_test

@export var highlight_material: StandardMaterial3D
var original_material: StandardMaterial3D

func _ready():
	if has_node("MeshInstance3D"):
		var mesh_instance: MeshInstance3D = $MeshInstance3D
		original_material = mesh_instance.mesh.surface_get_material(0)

func _add_highlight() -> void:
	if has_node("MeshInstance3D"):
		var mesh_instance: MeshInstance3D = $MeshInstance3D
		mesh_instance.set_surface_override_material(0, original_material.duplicate())
		mesh_instance.get_surface_override_material(0).next_pass = highlight_material

func _remove_highlight() -> void:
	if has_node("MeshInstance3D"):
		var mesh_instance: MeshInstance3D = $MeshInstance3D
		mesh_instance.set_surface_override_material(0, null)

func _on_interacted():
	print("hi")
