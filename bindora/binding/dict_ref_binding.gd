class_name DictRefBinding extends Binding
## Dictionary-based reference binding that manages multiple references by key
##
## Watches a dictionary of references and updates when any of them change.
## Automatically manages binding registration with each referenced value.

## Dictionary of references being watched, keyed by string identifiers
var refs: Dictionary[String, Ref]


func _init(_node: CanvasItem, _refs: Dictionary[String, Ref]) -> void:
		super(_node)
		refs = _refs
		for k in refs:
				refs[k].add_binding(self)
		pass


func destroy() -> void:
		for k in refs:
				refs[k].remove_binding(self)
		refs.clear()
		pass
