class_name MultiRefBinding extends Binding
## A binding that monitors multiple references simultaneously

var __refs__: Array[Ref]


func _init(_node: CanvasItem, _refs: Array[Ref]) -> void:
	super(_node)
	__refs__ = _refs
	for r in __refs__:
		r.value_updated.connect(_on_ref_value_changed)
	pass


func add_ref(_ref: Ref) -> void:
	if __refs__.has(_ref):
		return
	_ref.value_updated.connect(_on_ref_value_changed)
	__refs__.append(_ref)
	_on_ref_value_changed(null, null)
	pass


func remove_ref(_ref: Ref) -> void:
	if not __refs__.has(_ref):
		return
	_ref.value_updated.disconnect(_on_ref_value_changed)
	__refs__.erase(_ref)
	_on_ref_value_changed(null, null)
	pass


func _dispose() -> void:
	for ref in __refs__:
		ref.value_updated.disconnect(_on_ref_value_changed)
	super._dispose()
	pass
