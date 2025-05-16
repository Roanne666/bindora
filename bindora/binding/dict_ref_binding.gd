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
		for k in refs:
				refs[k].add_binding(self)
		pass


func add_ref(_property: String, _ref: Ref) -> void:
	if refs.has(_property):
		return
	_ref.add_binding(self)
	refs.set(_property, _ref)
	update(null)
	pass


func remove_ref(_property: String) -> void:
	if not refs.has(_property):
		return
	refs[_property].remove_binding(self)
	refs.erase(_property)
	update(null)
	pass


func destroy() -> void:
		for k in refs:
				refs[k].remove_binding(self)
		refs.clear()
		pass
