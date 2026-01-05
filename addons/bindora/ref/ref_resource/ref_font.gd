@tool
class_name RefFont
extends RefResource


func _init(_value: Font = null) -> void:
	super(_value, "Font")
	pass


func set_value(_value: Font) -> void:
	value = _value
	pass


func get_value() -> Font:
	return value
