@tool
class_name Ref extends Resource
## Reference class, foundation for reactivity

## Emitted when the value changes, providing both old and new values
signal value_updated(old_value, new_value)

## The expected type of the value this reference holds
@export_storage var type: Variant.Type = TYPE_NIL

## The actual stored value with custom setter logic
var value: Variant:
	set = _set_value


## Sets the value with type checking and conversion
func _set_value(_new_value: Variant) -> void:
	# type check
	var new_type = typeof(_new_value) as Variant.Type
	if not Engine.is_editor_hint():
		if type == TYPE_NIL:
			type = new_type
		elif type != new_type and not _type_convert_check(new_type):
			push_error("Type error, value should be %s" % type_string(new_type))
			return
		elif _new_value == value:
			return

	# convert
	if type == TYPE_DICTIONARY:
		var fixed_value: Dictionary[String, Ref] = {}
		for k in _new_value:
			var new_ref = Ref.new()
			new_ref.value = _new_value[k]
			fixed_value[k] = new_ref
		value_updated.emit(value, fixed_value)
		value = fixed_value
	elif type == TYPE_ARRAY:
		value = _new_value
		value_updated.emit(-1, null)
	else:
		var fixed_value = type_convert(_new_value, type)
		value_updated.emit(value, fixed_value)
		value = fixed_value
	pass

## Checks if type conversion between types is allowed
func _type_convert_check(_new_type: int) -> bool:
	if type == TYPE_STRING:
		if _new_type == TYPE_INT:
			return true
		elif _new_type == TYPE_FLOAT:
			return true
	elif type == TYPE_INT and _new_type == TYPE_FLOAT:
		return true
	elif type == TYPE_FLOAT and _new_type == TYPE_INT:
		return true
	return false


## Sets the value with type check.
func set_value(_value) -> void:
	value = _value
	pass


## Gets the current value with type.
func get_value() -> Variant:
	return value


func _init(_value = null) -> void:
	if _value != null:
		value = _value
	pass


func _get_property_list() -> Array[Dictionary]:
	return [ {"name": "value", "type": type, "usage": PROPERTY_USAGE_DEFAULT}]


## Creates a custom binding with a callable.
func bind_custom(_node: CanvasItem, _callable: Callable) -> CustomBinding:
	return CustomBinding.new(_node, [self], _callable)


## Creates a [SingleWatcher] for this reference
func create_watcher(_callable: Callable) -> SingleWatcher:
	return SingleWatcher.new(self, _callable)
