class_name ShowBinding extends SingleRefBinding
## Visibility binding that dynamically controls node visibility
##
## Uses a callback function to determine visibility based on a reference value.
## Automatically updates when the reference value changes.

## The condition function that determines visibility
var __callable__: Callable


func _init(_node: CanvasItem, _ref: RefVariant, _callable: Callable) -> void:
	super (_node, _ref)
	__callable__ = _callable
	_update(null, __ref__.value)
	pass


func _update(_old_value, _new_value) -> void:
	var should_show = __callable__.call(_new_value)
	__node__.set_visible(should_show)
	pass
