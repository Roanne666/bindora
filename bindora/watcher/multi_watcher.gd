class_name MultiWatcher extends Watcher

var refs: Array[Ref]


func _init(_refs: Array[Ref], _callable: Callable) -> void:
	refs = _refs
	callable = _callable
	for r in refs:
		r.add_watcher(self)
	pass


func add_ref(_ref: Ref) -> void:
	if refs.has(_ref):
		return
	refs.append(_ref)
	_ref.add_watcher(self)
	pass


func remove_ref(_ref: Ref) -> void:
	if not refs.has(_ref):
		return
	refs.erase(_ref)
	_ref.remove_watcher(self)
	pass


func update() -> void:
	var refs_values = refs.map(func(ref: Ref): return ref.value)
	callable.call(refs_values)
	pass


func destroy() -> void:
	for r in refs:
		r.remove_watcher(self)
	refs.clear()
	pass
