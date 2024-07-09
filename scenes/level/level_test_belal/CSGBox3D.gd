extends Spatial

# Reference to the object and its material
var object : Spatial
var material : ShaderMaterial

func _ready():
	object = $Path/To/Your/Object
	material = ShaderMaterial.new()
	material.shader = load("res://path/to/your/shader.shader")
	object.material_override = material

	# Set the rendering passes
	var outline_pass = Pass.new()
	outline_pass.depth_draw_mode = Pass.DRAW_ALWAYS

	material.render_priority = 2
	material.pass = outline_pass
