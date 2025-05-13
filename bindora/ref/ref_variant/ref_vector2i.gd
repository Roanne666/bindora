@tool
class_name RefVector2i extends RefVariant


func set_value(_value: Vector2i) -> void:
	value = _value
	pass


func get_value() -> Vector2i:
	return value


func _init(_value:=Vector2i()) -> void:
	type = TYPE_VECTOR2I
	super(_value)
	pass
