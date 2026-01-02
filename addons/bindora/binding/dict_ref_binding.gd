class_name DictRefBinding extends Binding
## Dictionary-based reference binding that manages multiple references by key

var __refs__: Dictionary[String, Ref]


func _init(_node: CanvasItem, _refs: Dictionary[String, Ref]) -> void:
	super(_node)
	__refs__ = _refs
	for k in _refs:
		_refs[k].value_updated.connect(_on_ref_value_changed)
	pass


func add_ref(_property: String, _ref: Ref) -> void:
	if __refs__.has(_property):
		return
	_ref.value_updated.connect(_on_ref_value_changed)
	__refs__.set(_property, _ref)
	_on_ref_value_changed(null, null)
	pass


func remove_ref(_property: String) -> void:
	if not __refs__.has(_property):
		return
	__refs__[_property].value_updated.disconnect(_on_ref_value_changed)
	__refs__.erase(_property)
	_on_ref_value_changed(null, null)
	pass


func _dispose() -> void:
	for k in __refs__:
		__refs__[k].value_updated.disconnect(_on_ref_value_changed)
	super._dispose()
	pass
