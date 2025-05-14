class_name Watcher extends RefCounted
## A watcher class that observes changes and executes callbacks

## The callback function to be executed when updates occur
var callable: Callable


func _init(_arg: Variant, _callable: Callable) -> void:
	callable = _callable
	pass


## Triggers the watcher's callback
func update() -> void:
	callable.call()
	pass


## Cleanup method for the watcher
func destroy() -> void:
	pass
