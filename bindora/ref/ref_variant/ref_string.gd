@tool
class_name RefString extends RefVariant


func set_value(_value: String) -> void:
	value = _value
	pass


func get_value() -> String:
	return value


func _init(_value := String()) -> void:
	__type__ = TYPE_STRING
	super (_value)
	pass
