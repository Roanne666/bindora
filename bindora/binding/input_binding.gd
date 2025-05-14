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

	update(ref.value)
	pass


## Handles text input changes
func _on_text_changed() -> void:
	if property:
		# Update object property if different
		if ref.value[property] != node.text:
			ref.value[property] = node.text

		# Update direct value if different
	else:
		# Update direct value if different
		if ref.value != node.text:
			ref.value = node.text
	pass


## Handles numeric/color value changes
func _on_value_changed(_value) -> void:
	if property:
		# Update object property
		ref.value[property] = _value
	else:
		# Update direct value
		ref.value = _value
	pass


func update(_value) -> void:
	# Handle property binding if specified
	if property != "":
		_value = _value[property]

	# Update control based on signal type
	match signal_type:
		"text_changed":
			if node["text"] != str(_value):
				node.text = str(_value)
		"value_changed":
			if node["value"] != _value:
				node.set_value_no_signal(_value)
		"color_changed":
			if node["color"] != _value:
				node["color"] = _value
	pass
