class_name VisibleBinding extends SingleRefBinding
## Visibility binding that dynamically controls node visibility
##
## Uses a callback function to determine visibility based on a reference value.
## Automatically updates when the reference value changes.

## The condition that determines visibility
var __condition__


func _init(_node: CanvasItem, _ref: RefVariant, _condition) -> void:
	super(_node, _ref)
	
	if not (_condition is Ref or _condition is Callable):
		push_error("VisibleBinding: Condition must be Ref or Callable, got %s" % typeof(_condition))
		return

	__condition__ = _condition
	_update(null, __ref__.value)
	pass


func _update(_old_value, _new_value) -> void:
	if __condition__ is Ref:
		__node__.set_visible(__condition__.value)
	elif __condition__ is Callable:
		__node__.set_visible(__condition__.call(_new_value))
	pass
