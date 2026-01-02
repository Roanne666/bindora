class_name CheckBoxBinding extends SingleRefBinding
## Checkbox binding that connects a checkbox to a RefArray value.
##
## Requires the target node to have a "toggled" signal.
## Manages two-way binding between checkbox state and array membership.

## The string value that represents this checkbox's value in the array
var __value__: String


func _init(_node: CanvasItem, _ref: RefArray, _value: String) -> void:
	super(_node, _ref)
	__value__ = _value
	
	if "toggled" in _node:
		_node.toggled.connect(func(_toggled_on: bool): _on_node_toggled(_toggled_on))
	else:
		push_error("CheckBoxBinding: Node '%s' missing 'toggled' signal" % _node.name)
		return

	__ref__.value_updated.connect(_update)
	_update([], __ref__.value)
	pass


func _on_node_toggled(_toggled_on: bool) -> void:
	if _toggled_on:
		__ref__.append(__value__)
	else:
		__ref__.erase(__value__)
	pass


func _update(_old_value, _new_value) -> void:
	__node__.set_pressed_no_signal(__value__ in __ref__.value)
	pass
