class_name DictRefBinding extends Binding
## Dictionary-based reference binding that manages multiple references by key
##
## Watches a dictionary of references and updates when any of them change.
## Automatically manages binding registration with each referenced value.

## Dictionary of references being watched, keyed by string identifiers
var refs: Dictionary[String, Ref]

func _init(_node: CanvasItem, _refs: Dictionary[String, Ref]) -> void:
	super (_node)
	refs = _refs
	for k in _refs:
		_refs[k].value_updated.connect(_on_ref_value_changed)
	pass

func add_ref(_property: String, _ref: Ref) -> void:
	if refs.has(_property):
		return
	_ref.value_updated.connect(_on_ref_value_changed)
	refs.set(_property, _ref)
	_on_ref_value_changed(null, null)
	pass


func remove_ref(_property: String) -> void:
	if not refs.has(_property):
		return
	refs[_property].value_updated.disconnect(_on_ref_value_changed)
	refs.erase(_property)
	_on_ref_value_changed(null, null)
	pass


func _dispose() -> void:
	for k in refs:
		refs[k].value_updated.disconnect(_on_ref_value_changed)
	refs.clear()
	super._dispose()
	pass
