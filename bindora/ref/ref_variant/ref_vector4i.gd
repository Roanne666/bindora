@tool
class_name RefVector4i extends RefVariant


func set_value(_value: Vector4i) -> void:
	value = _value
	pass


func get_value() -> Vector4i:
	return value


func _init(_value:=Vector4i()) -> void:
	type = TYPE_VECTOR4I
	super (_value)
	pass
