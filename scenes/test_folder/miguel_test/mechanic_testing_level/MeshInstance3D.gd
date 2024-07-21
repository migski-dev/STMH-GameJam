extends MeshInstance3D

var shader_material : ShaderMaterial
@export var rigid_body: RigidBody3D

func _ready():
	shader_material = self.get_active_material(0).next_pass
	toggle_shader(false)

func toggle_shader(enable: bool):
	shader_material.set_shader_parameter("enable_shader", enable)

func _physics_process(delta):
	if GameData.light_blocking_object == self or GameData.light_blocking_object == rigid_body:
		toggle_shader(true)
	else:
		toggle_shader(false)
