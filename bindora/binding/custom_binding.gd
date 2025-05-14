class_name CustomBinding extends MultiRefBinding
## Custom binding that executes a provided function when referenced values change
##
## This binding allows for custom behavior when any of the watched references update.
## The provided callable will be invoked with the bound node and array of references.

## The function to execute when any bound reference changes
## Signature: func(node: CanvasItem, refs: Array[Ref]) -> void
var callable: Callable


func _init(_node: CanvasItem, _refs: Array[Ref], _callable: Callable) -> void:
	super (_node, _refs)
	callable = _callable
	pass


func update(_value: Variant) -> void:
	callable.call(node, refs)
	pass
