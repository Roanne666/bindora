@tool
class_name RefSignal extends RefVariant


func set_value(_value: Signal) -> void:
	value = _value
	pass


func get_value() -> Signal:
	return value


func _init(_value:=Signal()) -> void:
	type = TYPE_SIGNAL
	super(_value)
	pass
