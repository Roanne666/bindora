class_name Binding extends Object
## Base binding class that connects reference values to nodes.
##
## This serves as the foundation for creating reactive bindings between data
## and UI elements or other nodes in the scene tree.

## The target node this binding is attached to.
var __node__: Node


## Initializes the binding with a target node
func _init(_node: CanvasItem) -> void:
	__node__ = _node
	__node__.tree_exiting.connect(_dispose)
	pass


func _on_ref_value_changed(_old_value, _new_value) -> void:
	if __node__ == null:
		_dispose()
	else:
		_update(_old_value, _new_value)
	pass

## Updates the binding with a new value
func _update(_old_value, _new_value) -> void:
	pass


## Cleans up the binding resources
func _dispose() -> void:
	if __node__ and __node__.tree_exiting.is_connected(_dispose):
		__node__.tree_exiting.disconnect(_dispose)
	call_deferred("free")
	pass
