class_name MultiRefBinding extends Binding
## A binding that monitors multiple references simultaneously
##
## This binding reacts to changes in any of its watched references.
## Automatically manages binding registration with all provided references.

## Array of references being monitored by this binding
var refs: Array[Ref]
var __callables__: Dictionary[Ref, Callable] = {}

func _init(_node: CanvasItem, _refs: Array[Ref]) -> void:
	super (_node)
	refs = _refs
	for r in refs:
		__callables__[r] = _create_connect_callable()
		r.value_updated.connect(__callables__[r])
	pass


func add_ref(_ref: Ref) -> void:
	if refs.has(_ref):
		return
	__callables__[_ref] = _create_connect_callable()
	_ref.value_updated.connect(__callables__[_ref])
	refs.append(_ref)
	_on_ref_value_changed(null, null)
	pass


func remove_ref(_ref: Ref) -> void:
	if not refs.has(_ref):
		return
	_ref.value_updated.disconnect(__callables__[_ref])
	__callables__.erase(_ref)
	refs.erase(_ref)
	_on_ref_value_changed(null, null)
	pass

func destroy() -> void:
	for ref in refs:
		ref.value_updated.disconnect(__callables__[ref])
	__callables__.clear()
	refs.clear()
	pass
