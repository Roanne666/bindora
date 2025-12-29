@tool
class_name RefTexture extends RefResource


func set_value(_value: Texture) -> void:
	value = _value
	pass


func get_value() -> Texture:
	return value


func _init(_value: Texture = null) -> void:
	super(_value, "Texture")
	pass
