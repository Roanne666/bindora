class_name InputBinding extends SingleRefBinding
## Input binding for UI controls that support text/value changes
##
## Binds input controls (like LineEdit, SpinBox, ColorPicker) to reference values.
## Supports three types of input signals:
## - text_changed (for text inputs)
## - value_changed (for numeric inputs)
## - color_changed (for color pickers)
## Can bind to either direct values or object properties.

## The property name to bind to (empty for direct value binding)
var property: String

## The detected signal type ("text_changed", "value_changed", or "color_changed")
var signal_type: String


func _init(_node: CanvasItem, _ref: RefVariant, _property: String = "") -> void:
	super (_node, _ref)
	property = _property

	# Detect and connect appropriate signal
	if "text_changed" in _node:
		signal_type = "text_changed"
		_node.text_changed.connect(func(): _on_text_changed())
	elif "value_changed" in _node:
		signal_type = "value_changed"
		_node.value_changed.connect(func(_value): _on_value_changed(_value))
	elif "color_changed" in _node:
		signal_type = "color_changed"
		_node.color_changed.connect(func(_value): _on_value_changed(_value))
	else:
		push_error("Node doesn't have signal 'text_changed' or 'value_changed'")

	_update(null, ref.value)
	pass


## Handles text input changes
func _on_text_changed() -> void:
	if property:
		if ref.value[property] != node.text:
			ref.value[property] = node.text
	else:
		if ref.get_value() != node.text:
			ref.set_value(node.text)
	pass


## Handles numeric/color value changes
func _on_value_changed(_value) -> void:
	if property:
		ref.value[property] = _value
	else:
		ref.set_value(_value)
	pass


func _update(_old_value, _new_value) -> void:
	# Handle property binding if specified
	if property != "":
		_new_value = _new_value[property]

	# Update control based on signal type
	match signal_type:
		"text_changed":
			if node["text"] != str(_new_value):
				node.set("text", str(_new_value))
		"value_changed":
			if node["value"] != _new_value:
				node.set_value_no_signal(_new_value)
		"color_changed":
			if node["color"] != _new_value:
				node.set("color", _new_value)
	pass
