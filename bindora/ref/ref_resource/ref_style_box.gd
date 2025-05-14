@tool
class_name RefStyleBox extends RefResource


func set_value(_value: StyleBox) -> void:
	value = _value
	pass


func get_value() -> StyleBox:
	return value


func _init(_value: StyleBox = null) -> void:
	type = TYPE_OBJECT
	resource_type = "StyleBox"
	super (_value)
	pass
