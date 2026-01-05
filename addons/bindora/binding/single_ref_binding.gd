class_name SingleRefBinding
extends Binding
## A binding that monitors a single reference

var __ref__: Ref


func _init(_node: CanvasItem, _ref: Ref) -> void:
	super(_node)
	__ref__ = _ref
	__ref__.value_updated.connect(_on_ref_value_changed)
	pass


func _dispose() -> void:
	if not is_instance_valid(__ref__):
		return
	__ref__.value_updated.disconnect(_on_ref_value_changed)
	__ref__ = null
	super._dispose()
	pass
