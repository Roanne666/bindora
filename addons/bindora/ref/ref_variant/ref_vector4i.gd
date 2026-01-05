@tool
class_name RefVector4i
extends RefVariant


func _init(_value := Vector4i()) -> void:
	super(TYPE_VECTOR4I, _value)
	pass


func set_value(_value: Vector4i) -> void:
	value = _value
	pass


func get_value() -> Vector4i:
	return value
