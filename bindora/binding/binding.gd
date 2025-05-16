class_name Binding extends RefCounted
## Base binding class that connects reference values to nodes.
##
## This serves as the foundation for creating reactive bindings between data
## and UI elements or other nodes in the scene tree.

## The target node this binding is attached to.
var node: Node


## Initializes the binding with a target node
func _init(_node: CanvasItem) -> void:
	node = _node
	pass


func _create_connect_callable() -> Callable:
	return func(_old_value, _new_value): _on_ref_value_changed(_old_value, _new_value)


func _on_ref_value_changed(_old_value, _new_value) -> void:
	if node == null:
		destroy()
	else:
		_update(_old_value, _new_value)


## Updates the binding with a new value
func _update(_old_value, _new_value) -> void:
	pass


## Cleans up the binding resources
func destroy() -> void:
	pass
