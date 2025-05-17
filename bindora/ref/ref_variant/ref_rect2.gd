@tool
class_name RefRect2 extends RefVariant


func set_value(_value: Rect2) -> void:
	value = _value
	pass


func get_value() -> Rect2:
	return value


func _init(_value := Rect2()) -> void:
	__type__ = TYPE_RECT2
	super (_value)
	pass
