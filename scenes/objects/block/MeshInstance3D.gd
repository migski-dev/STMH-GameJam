extends MeshInstance3D

var shader_material : ShaderMaterial
@export var static_body: StaticBody3D

func _ready() -> void:
	#EventManager.on_player_enter_new_shadow.connect(_on_player_enter_new_shadow)
	CameraTransition.possession_enter_complete.connect(_on_player_enter_possession)
	CameraTransition.possession_exit_complete.connect(_on_player_exit_possession)
	shader_material = self.get_active_material(0).next_pass
	toggle_shader(false)
	#toggle_shader(true)
	
func toggle_shader(enable: bool) -> void:
	shader_material.set_shader_parameter("enable_shader", enable)
#
#func _on_player_enter_new_shadow() -> void: 
	#if(static_body == null):
		#return
	#if(EventManager.light_blocking_object == static_body):
		#toggle_shader(true)
	#else: 
		#toggle_shader(false)
		#toggle_shader(true)

func _on_player_enter_possession() -> void: 
	if(static_body == null):
		return
	if(EventManager.light_blocking_object == static_body):
		toggle_shader(true)
		#toggle_shader(true)

func _on_player_exit_possession() -> void: 
	toggle_shader(false)
