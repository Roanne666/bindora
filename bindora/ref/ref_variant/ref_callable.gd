@tool
class_name RefCallable extends RefVariant


func set_value(_value: Callable) -> void:
	value = _value
	pass


func get_value() -> Callable:
	return value


func _init(_value := Callable()) -> void:
	type = TYPE_CALLABLE
	super(_value)
	pass
