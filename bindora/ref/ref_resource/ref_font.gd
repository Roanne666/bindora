@tool
class_name RefFont extends RefResource


func set_value(_value: Font) -> void:
	value = _value
	pass


func get_value() -> Font:
	return value


func _init(_value: Font = null) -> void:
	type = TYPE_OBJECT
	resource_type = "Font"
	super (_value)
	pass
