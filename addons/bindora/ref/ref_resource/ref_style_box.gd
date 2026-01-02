@tool
class_name RefStyleBox extends RefResource


func set_value(_value: StyleBox) -> void:
	value = _value
	pass


func get_value() -> StyleBox:
	return value


func _init(_value: StyleBox = null) -> void:
	super(_value, "StyleBox")
	pass
