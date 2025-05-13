class_name RadioBinding extends SingleRefBinding
## Radio button binding for exclusive selection behavior
##
## Binds a radio button to a reference value, automatically handling:
## - Setting the reference value when button is toggled on
## - Visual state updates when reference changes
## Requires the node to have a "toggled" signal.

## The value this radio button represents when selected
var value: String


func _init(_node: CanvasItem, _ref: RefVariant, _value: String) -> void:
	super(_node, _ref)
	value = _value
	if "toggled" in _node:
		_node.toggled.connect(func(_toggled_on: bool): if _toggled_on: ref.value=value)
	update(ref.value)
	pass


func update(_new_value: String) -> void:
	node.set_pressed_no_signal(value == _new_value)
	pass
