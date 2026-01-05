@tool
class_name RefVector3i
extends RefVariant


func _init(_value := Vector3i()) -> void:
	super(TYPE_VECTOR3I, _value)
	pass


func set_value(_value: Vector3i) -> void:
	value = _value
	pass


func get_value() -> Vector3i:
	return value
