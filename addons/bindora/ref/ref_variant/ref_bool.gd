@tool
class_name RefBool extends RefVariant


func set_value(_value: bool) -> void:
	value = _value
	pass


func get_value() -> bool:
	return value


func _init(_value:=bool()) -> void:
	super(TYPE_BOOL, _value)
	pass
