class_name ShaderBinding extends DictRefBinding
## Shader parameter binding for ShaderMaterial properties
##
## Automatically updates shader parameters when bound reference values change.
## Requires:
## - Node with "material" property containing a ShaderMaterial
## - Valid shader parameter names matching dictionary keys


func _init(_node: CanvasItem, _refs: Dictionary[String, Ref]) -> void:
	super(_node, _refs)
	if "material" in __node__ and __node__.material != null:
		_update(null, null)
	else:
		push_error("ShaderBinding: Node '%s' missing 'material' property with ShaderMaterial" % __node__.name)
	pass


func _update(_old_value, _new_value) -> void:
	var material = __node__.get("material") as ShaderMaterial
	for param_name in __refs__:
		material.set_shader_parameter(param_name, __refs__[param_name].value)
	pass
