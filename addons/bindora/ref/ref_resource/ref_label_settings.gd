@tool
class_name RefLabelSettings
extends RefResource


func _init(_value: LabelSettings = null) -> void:
	super(_value, "LabelSettings")
	pass


func set_value(_value: LabelSettings) -> void:
	value = _value
	pass


func get_value() -> LabelSettings:
	return value
