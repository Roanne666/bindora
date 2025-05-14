@tool
class_name RefColor extends RefVariant


func get_value() -> Color:
	return value


func _init(_value:=Color()) -> void:
	type = TYPE_COLOR
	super (_value)
	pass
