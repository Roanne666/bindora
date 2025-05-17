@tool
class_name RefRect2i extends RefVariant


func set_value(_value: Rect2i) -> void:
	value = _value
	pass


func get_value() -> Rect2i:
	return value


func _init(_value := Rect2i()) -> void:
	__type__ = TYPE_RECT2I
	super (_value)
	pass
