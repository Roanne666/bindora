@tool
class_name RefVector2 extends RefVariant


func set_value(_value: Vector2) -> void:
	value = _value
	pass


func get_value() -> Vector2:
	return value


func _init(_value:=Vector2()) -> void:
	type = TYPE_VECTOR2
	super (_value)
	pass
