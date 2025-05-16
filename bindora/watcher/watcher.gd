class_name Watcher extends RefCounted
## A watcher class that observes changes and executes callbacks

## The callback function to be executed when updates occur
var callable: Callable


func _init(_arg: Variant, _callable: Callable) -> void:
	callable = _callable
	pass


func _create_connect_callable() -> Callable:
	return func(_old_value, _new_value): _update(_old_value, _new_value)


## Triggers the watcher's callback
func _update(_old_value, _new_value) -> void:
	callable.call(self)
	pass


## Cleanup method for the watcher
func destroy() -> void:
	pass
