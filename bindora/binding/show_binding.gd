class_name ShowBinding extends SingleRefBinding
## Visibility binding that dynamically controls node visibility
##
## Uses a callback function to determine visibility based on a reference value.
## Automatically updates when the reference value changes.

## The condition function that determines visibility
var callable: Callable


func _init(_node: CanvasItem, _ref: RefVariant, _callable: Callable) -> void:
	super(_node, _ref)
	callable = _callable
	update(ref.value)
	pass


func update(_value: Variant) -> void:
	var should_show = callable.call(_value)
	node.set_visible(should_show)
	pass
