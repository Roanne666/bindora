class_name ToggleBinding extends SingleRefBinding
## Toggle binding for boolean state synchronization
##
## Requires the target node to have a "toggled" property. (like [CheckBox])
## Two-way binding between node and reference.
## Optional opposite mode.

## When true, inverts the toggle state (checked = false, unchecked = true)
var __opposite__: bool


func _init(_node: CanvasItem, _ref: RefBool, _opposite: bool = false) -> void:
	super(_node, _ref)
	__opposite__ = _opposite

	if "toggled" in __node__:
		__node__.toggled.connect(func(_toggled_state: bool): _on_toggled(_toggled_state))
	else:
		push_error("ToggleBinding: Node '%s' missing 'toggled' signal" % _node.name)
		return

	_update(null, __ref__.value)
	pass


## Handles toggle state changes from the node
func _on_toggled(_toggled_state: bool) -> void:
	var ref_value = not _toggled_state if __opposite__ else _toggled_state
	__ref__.value = ref_value
	pass


func _update(_old_value, _new_value) -> void:
	var node_state = not _new_value if __opposite__ else _new_value
	if __node__["button_pressed"] != node_state:
		__node__["button_pressed"] = node_state
	pass
