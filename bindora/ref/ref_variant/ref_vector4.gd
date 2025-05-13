@tool
class_name RefVector4 extends RefVariant


func set_value(_value: Vector4) -> void:
	value = _value
	pass


func get_value() -> Vector4:
	return value


func _init(_value:=Vector4()) -> void:
	type = TYPE_VECTOR4
	super(_value)
	pass
