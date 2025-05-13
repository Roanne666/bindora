class_name SingleRefBinding extends Binding

var ref: Ref


func _init(_node: CanvasItem, _ref: Ref) -> void:
	super(_node)
	ref = _ref
	ref.add_binding(self)
	pass


func destroy() -> void:
	if ref == null:
		return
	ref.remove_binding(self)
	ref = null
	pass
