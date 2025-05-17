@tool
class_name RefVector3 extends RefVariant


func set_value(_value: Vector3) -> void:
	value = _value
	pass


func get_value() -> Vector3:
	return value


func _init(_value := Vector3()) -> void:
	__type__ = TYPE_VECTOR3
	super (_value)
	pass
