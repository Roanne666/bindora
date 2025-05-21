class_name SingleRefBinding extends Binding

var ref: Ref

func _init(_node: CanvasItem, _ref: Ref) -> void:
	super (_node)
	ref = _ref
	ref.value_updated.connect(_on_ref_value_changed)
	pass


func _dispose() -> void:
	if ref == null:
		return
	ref.value_updated.disconnect(_on_ref_value_changed)
	ref = null
	super._dispose()
	pass
