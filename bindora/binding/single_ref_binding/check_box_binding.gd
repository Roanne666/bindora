class_name CheckBoxBinding extends SingleRefBinding
## Checkbox binding that connects a checkbox to a RefArray value.
##
## Requires the target node to have a "toggled" signal.
## Manages two-way binding between checkbox state and array membership.

## The string value that represents this checkbox's value in the array
var value: String


func _init(_node: CanvasItem, _ref: RefArray, _value: String) -> void:
	super (_node, _ref)
	value = _value
	if "toggled" in _node:
		_node.toggled.connect(func(_toggled_on: bool): _on_node_toggled(_toggled_on))
	ref.value_updated.connect(_update)
	_update([], _ref.value)
	pass


func _on_node_toggled(_toggled_on: bool) -> void:
	if _toggled_on:
		ref.append(value)
	else:
		ref.erase(value)
	pass


func _update(_old_value, _new_value) -> void:
	node.set_pressed_no_signal(value in ref.value)
	pass
