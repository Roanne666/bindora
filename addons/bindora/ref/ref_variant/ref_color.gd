@tool
class_name RefColor
extends RefVariant


func _init(_value := Color()) -> void:
	super(TYPE_COLOR, _value)
	pass


func get_value() -> Color:
	return value
