extends CSGBox3D

class_name interactable_test

var shader_material : ShaderMaterial

func _ready():
	shader_material = self.material.next_pass
	toggle_shader(false)

func toggle_shader(enable: bool):
	shader_material.set_shader_parameter("enable_shader", enable)

func _on_interacted():
	print("hi")

func _physics_process(delta):
	if EventManager.light_blocking_object == self:
		toggle_shader(true)
	else:
		toggle_shader(false)
