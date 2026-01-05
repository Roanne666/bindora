@tool
class_name RefRect2i
extends RefVariant


func _init(_value := Rect2i()) -> void:
	super(TYPE_RECT2I, _value)
	pass


func set_value(_value: Rect2i) -> void:
	value = _value
	pass


func get_value() -> Rect2i:
	return value
