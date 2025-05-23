class_name TextBinding extends DictRefBinding
## Text binding with template interpolation for dynamic text content
##
## Binds multiple references to a text node with template replacement.
## Requires the target node to have a "text" property.
## Supports template syntax like `{{variable}}` that gets replaced with reference values.

## The template string containing {{placeholder}} markers for interpolation
var __template__: String


func _init(_node: CanvasItem, _refs: Dictionary[String, Ref], _template: String = "") -> void:
	super (_node, _refs)
	if "text" in __node__:
		# Use existing text as template if none provided
		__template__ = __node__.get("text") if _template.is_empty() else _template
	else:
		push_error("Node missing required 'text' property")
	_on_ref_value_changed(null, null)
	pass


func _update(_old_value, _new_value) -> void:
	var output_text = __template__

	# Replace all template placeholders with current values
	for placeholder in __refs__:
		output_text = output_text.replacen("{{%s}}" % placeholder, str(__refs__[placeholder].value))

	# Only update if text actually changed
	if __node__.text != output_text:
		__node__.text = output_text
