extends MeshInstance3D

var shader_material : ShaderMaterial
@export var static_body: StaticBody3D

func _ready() -> void:
	EventManager.on_player_enter_new_shadow.connect(_on_player_enter_new_shadow)
	shader_material = self.get_active_material(0).next_pass
	toggle_shader(false)
#
func toggle_shader(enable: bool) -> void:
	shader_material.set_shader_parameter("player_in_shadow", enable)
#
func _on_player_enter_new_shadow() -> void: 
	if(static_body == null):
		return
	if(EventManager.light_blocking_object == static_body):
		toggle_shader(true)
	else: 
		toggle_shader(false)


