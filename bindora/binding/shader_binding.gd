class_name ShaderBinding extends DictRefBinding
## Shader parameter binding for ShaderMaterial properties
##
## Automatically updates shader parameters when bound reference values change.
## Requires:
## - Node with "material" property containing a ShaderMaterial
## - Valid shader parameter names matching dictionary keys


func _init(_node: CanvasItem, _refs: Dictionary[String, Ref]) -> void:
	super(_node, _refs)
	if "material" in node:
		update("")
	else:
		push_error("Node missing required 'material' property")
	pass


func update(_value) -> void:
	var material = node.get("material") as ShaderMaterial
	for param_name in refs:
		material.set_shader_parameter(param_name, refs[param_name].value)
	pass
