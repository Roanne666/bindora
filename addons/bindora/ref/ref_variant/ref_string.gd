@tool
class_name RefString
extends RefVariant


func _init(_value := String()) -> void:
	super(TYPE_STRING, _value)
	pass


func set_value(_value: String) -> void:
	value = _value
	pass


func get_value() -> String:
	return value
