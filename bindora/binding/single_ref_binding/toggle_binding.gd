class_name ToggleBinding extends SingleRefBinding
## Toggle binding for boolean state synchronization
##
## Requires the target node to have a "toggled" property. (like [CheckBox])
## Two-way binding between node and reference.
## Optional opposite/inverse mode.

## When true, inverts the toggle state (checked = false, unchecked = true)
var opposite: bool


func _init(_node: CanvasItem, _ref: RefBool, _opposite: bool = false) -> void:
	super (_node, _ref)
	opposite = _opposite
	if "toggled" in node:
		node.toggled.connect(func(toggled_state: bool): _on_toggled(toggled_state))
	else:
		push_error("Node missing required 'toggled' signal")
	_update(null, ref.value)
	pass


## Handles toggle state changes from the node
func _on_toggled(toggled_state: bool) -> void:
	var ref_value = not toggled_state if opposite else toggled_state
	ref.value = ref_value
	pass


func _update(_old_value, _new_value) -> void:
	var node_state = not _new_value if opposite else _new_value
	if node["button_pressed"] != node_state:
		node["button_pressed"] = node_state
	pass
