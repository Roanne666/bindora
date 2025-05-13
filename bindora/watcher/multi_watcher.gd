class_name MultiWatcher extends Watcher

var refs: Array[Ref]


func _init(_refs: Array[Ref], _callable: Callable) -> void:
	refs = _refs
	callable = _callable
	for r in refs:
		r._watchers.append(self)
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
