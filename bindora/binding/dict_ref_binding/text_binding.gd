class_name TextBinding extends DictRefBinding
## Text binding with template interpolation for dynamic text content
##
## Binds multiple references to a text node with template replacement.
## Requires the target node to have a "text" property.
## Supports template syntax like `{{variable}}` that gets replaced with reference values.

## The template string containing {{placeholder}} markers for interpolation
var template: String


func _init(_node: CanvasItem, _refs: Dictionary[String, Ref], _template: String = "") -> void:
	super (_node, _refs)
	if "text" in node:
		# Use existing text as template if none provided
		template = node.get("text") if _template.is_empty() else _template
	else:
		push_error("Node missing required 'text' property")
	_update(null, null)
	pass


func _update(_old_value, _new_value) -> void:
	if node == null:
		destroy()
		return

	var output_text = template

	# Replace all template placeholders with current values
	for placeholder in refs:
		output_text = output_text.replacen("{{%s}}" % placeholder, str(refs[placeholder].value))

	# Only update if text actually changed
	if node.text != output_text:
		node.text = output_text
