class_name MultiRefBinding extends Binding
## A binding that monitors multiple references simultaneously
##
## This binding reacts to changes in any of its watched references.
## Automatically manages binding registration with all provided references.

## Array of references being monitored by this binding
var refs: Array[Ref]


func _init(_node: CanvasItem, _refs: Array[Ref]) -> void:
	super (_node)
	refs = _refs
	for r in refs:
		r.add_binding(self)
	pass


func add_ref(_ref: Ref) -> void:
	if refs.has(_ref):
		return
	_ref.add_binding(self)
	refs.append(_ref)
	update(null)
	pass


func remove_ref(_ref: Ref) -> void:
	if not refs.has(_ref):
		return
	_ref.remove_binding(self)
	refs.erase(_ref)
	update(null)
	pass

func destroy() -> void:
	for ref in refs:
		ref.remove_binding(self)
	refs.clear()
	pass
