class_name RadioBinding extends SingleRefBinding
## Radio button binding for exclusive selection behavior
##
## Binds a radio button to a reference value, automatically handling:
## - Setting the reference value when button is toggled on
## - Visual state updates when reference changes
## Requires the node to have a "toggled" signal.

## The value this radio button represents when selected
var __value__: String


func _init(_node: CanvasItem, _ref: RefVariant, _value: String) -> void:
	super(_node, _ref)
	__value__ = _value
	
	if "toggled" in _node:
		_node.toggled.connect(func(_toggled_on: bool): if _toggled_on: __ref__.value=__value__)
	else:
		push_error("RadioBinding: Node '%s' missing 'toggled' signal" % _node.name)
		return

	_on_ref_value_changed(null, __ref__.value)
	pass


func _update(_old_value, _new_value) -> void:
	__node__.set_pressed_no_signal(__value__ == _new_value)
	pass
