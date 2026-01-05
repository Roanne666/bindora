@tool
class_name RefMaterial
extends RefResource


func _init(_value: Material = null) -> void:
	super(_value, "Material")
	pass


func set_value(_value: Material) -> void:
	value = _value
	pass


func get_value() -> Material:
	return value
