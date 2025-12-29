@tool
class_name RefVector2i extends RefVariant


func set_value(_value: Vector2i) -> void:
	value = _value
	pass


func get_value() -> Vector2i:
	return value


func _init(_value:=Vector2i()) -> void:
	super(TYPE_VECTOR2I, _value)
	pass
