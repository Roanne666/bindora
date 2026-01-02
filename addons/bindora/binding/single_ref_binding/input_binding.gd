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
var __property__: String

## The detected signal type ("text_changed", "value_changed", or "color_changed")
var __signal_type__: String


func _init(_node: CanvasItem, _ref: RefVariant, _property: String = "") -> void:
	super(_node, _ref)
	__property__ = _property

	# Detect and connect appropriate signal
	if "text_changed" in _node:
		__signal_type__ = "text_changed"
		_node.text_changed.connect(func(): _on_text_changed())
	elif "value_changed" in _node:
		__signal_type__ = "value_changed"
		_node.value_changed.connect(func(_value): _on_value_changed(_value))
	elif "color_changed" in _node:
		__signal_type__ = "color_changed"
		_node.color_changed.connect(func(_value): _on_value_changed(_value))
	else:
		push_error("InputBinding: Node '%s' missing supported signal (text_changed, value_changed, or color_changed)" % _node.name)
		return
		
	_update(null, __ref__.value)
	pass


## Handles text input changes
func _on_text_changed() -> void:
	if __property__:
		if __ref__.value[__property__] != __node__.text:
			__ref__.value[__property__] = __node__.text
	else:
		if __ref__.get_value() != __node__.text:
			__ref__.set_value(__node__.text)
	pass


## Handles numeric/color value changes
func _on_value_changed(_value) -> void:
	if __property__:
		__ref__.value[__property__] = _value
	else:
		__ref__.set_value(_value)
	pass


func _update(_old_value, _new_value) -> void:
	# Handle property binding if specified
	if __property__ != "":
		_new_value = _new_value[__property__]

	# Update control based on signal type
	match __signal_type__:
		"text_changed":
			if __node__["text"] != str(_new_value):
				__node__.set("text", str(_new_value))
		"value_changed":
			if __node__["value"] != _new_value:
				__node__.set_value_no_signal(_new_value)
		"color_changed":
			if __node__["color"] != _new_value:
				__node__.set("color", _new_value)
	pass
