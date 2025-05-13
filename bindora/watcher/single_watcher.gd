class_name SingleWatcher extends Watcher

var ref: Ref


func _init(_ref: Ref, _callable: Callable) -> void:
	ref = _ref
	callable = _callable
	ref._watchers.append(self)
	pass


func update() -> void:
	callable.call(self, ref.value)
	pass


func destroy() -> void:
	if ref == null:
		return
	ref.remove_watcher(self)
	ref = null
	pass
