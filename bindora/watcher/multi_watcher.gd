class_name MultiWatcher extends Watcher

var refs: Array[Ref]
var __callables__: Dictionary[Ref, Callable] = {}

func _init(_refs: Array[Ref], _callable: Callable) -> void:
	refs = _refs
	callable = _callable
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
	pass


func remove_ref(_ref: Ref) -> void:
	if not refs.has(_ref):
		return
	_ref.value_updated.disconnect(__callables__[_ref])
	__callables__.erase(_ref)
	refs.erase(_ref)
	pass


func _update(_old_value, _new_value) -> void:
	var refs_values = refs.map(func(ref: Ref): return ref.value)
	callable.call(self, refs_values)
	pass


func destroy() -> void:
	for r in refs:
		r.value_updated.disconnect(__callables__[r])
	__callables__.clear()
	refs.clear()
	pass
