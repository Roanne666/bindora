class_name SingleWatcher extends Watcher

var ref: Ref
var __callable__ := _create_connect_callable()

func _init(_ref: Ref, _callable: Callable) -> void:
	ref = _ref
	callable = _callable
	ref.value_updated.connect(__callable__)
	pass


func _update(_old_value, _new_value) -> void:
	callable.call(self, _new_value)
	pass


func destroy() -> void:
	if ref == null:
		return
	ref.value_updated.disconnect(__callable__)
	ref = null
	pass
