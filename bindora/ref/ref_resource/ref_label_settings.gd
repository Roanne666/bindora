@tool
class_name RefLabelSettings extends RefResource


func set_value(_value: LabelSettings) -> void:
	value = _value
	pass


func get_value() -> LabelSettings:
	return value


func _init(_value: LabelSettings = null) -> void:
	type = TYPE_OBJECT
	resource_type = "LabelSettings"
	super (_value)
	pass
