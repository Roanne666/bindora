@tool
class_name RefInt extends RefVariant


func set_value(_value: int) -> void:
	value = _value
	pass


func get_value() -> int:
	return value


func _init(_value:=int()) -> void:
	super(TYPE_INT, _value)
	pass
