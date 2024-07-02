extends CSGBox3D

const OUTLINE_SHADER_PATH = "res://scenes/test_folder/belal_test/Outline.gdshader"

var original_material : Material
var outline_material : ShaderMaterial

func _ready():
	original_material = material
	var shader = load(OUTLINE_SHADER_PATH)
	outline_material = ShaderMaterial.new()
	outline_material.shader = shader

func enable_outline():
	material = outline_material

func disable_outline():
	material = original_material
