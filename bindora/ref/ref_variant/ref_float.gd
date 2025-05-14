@tool
class_name RefFloat extends RefVariant


func set_value(_value: float) -> void:
	value = _value
	pass


func get_value() -> float:
	return value


func _init(_value:=float()) -> void:
	type = TYPE_FLOAT
	super (_value)
	pass
