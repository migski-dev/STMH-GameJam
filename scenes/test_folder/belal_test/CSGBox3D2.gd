extends CSGBox3D

var shader_material : ShaderMaterial

func _ready():
	shader_material = self.material.next_pass
	toggle_shader(false)

func toggle_shader(enable: bool):
	shader_material.set_shader_parameter("enable_shader", enable)

func _physics_process(delta):
	if GameData.light_blocking_object == self:
		toggle_shader(true)
	else:
		toggle_shader(false)
