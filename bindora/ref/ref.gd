@tool
class_name Ref extends Resource
## Reference class, foundation for reactivity

## Emitted when the value changes, providing both old and new values
signal value_updated(old_value, new_value)

## The expected type of the value this reference holds
@export_storage var __type__: Variant.Type = TYPE_NIL

var __computed_refs__: Array[Ref] = []
var __computed_callable__: Callable

## The actual stored value with custom setter logic
var value: Variant:
	set = _set_value


## Sets the value with type checking and conversion
func _set_value(_new_value) -> void:
	# type check
	var new_type = typeof(_new_value) as Variant.Type
	if not Engine.is_editor_hint():
		if __type__ == TYPE_NIL:
			__type__ = new_type
		elif __type__ != new_type and not _type_convert_check(new_type):
			push_error("Type error, value should be %s" % type_string(new_type))
			return
		elif _new_value == value:
			return

	# convert
	if __type__ == TYPE_DICTIONARY:
		var fixed_value: Dictionary[String, Ref] = {}
		for k in _new_value:
			fixed_value[k] = Ref.new(typeof(_new_value[k]), _new_value[k])
		value_updated.emit(value, fixed_value)
		value = fixed_value
	elif __type__ == TYPE_ARRAY:
		value = _new_value
		value_updated.emit(-1, null)
	else:
		var fixed_value = type_convert(_new_value, __type__)
		value = fixed_value
		value_updated.emit(value, fixed_value)
	pass

## Checks if type conversion between types is allowed
func _type_convert_check(_new_type: int) -> bool:
	match __type__:
		TYPE_STRING:
			return _new_type in [TYPE_INT, TYPE_FLOAT, TYPE_BOOL]
		TYPE_INT:
			return _new_type in [TYPE_FLOAT, TYPE_BOOL]
		TYPE_FLOAT:
			return _new_type in [TYPE_INT, TYPE_BOOL]
		TYPE_BOOL:
			return _new_type in [TYPE_INT, TYPE_FLOAT]
		_:
			return false


## Sets the value with type check.
func set_value(_value) -> void:
	value = _value
	pass


## Gets the current value with type.
func get_value() -> Variant:
	return value


func _init(_type: Variant.Type, _value=null) -> void:
	__type__ = _type
	if _value != null:
		value = _value
	pass


func _get_property_list() -> Array[Dictionary]:
	return [ {"name": "value", "type": __type__, "usage": PROPERTY_USAGE_DEFAULT}]


## Creates a custom binding with a callable.
func bind_custom(_node: CanvasItem, _callable: Callable) -> CustomBinding:
	return CustomBinding.new(_node, [self], _callable)


## Make this reference a computed one.
func as_computed(_refs: Array[Ref], _callable: Callable) -> void:
	if __computed_callable__:
		for ref in __computed_refs__:
			ref.value_updated.disconnect(__computed_callable__)

	__computed_refs__ = _refs
	__computed_callable__ = func(_old_value, _new_value): set_value(_callable.call(__computed_refs__))

	for ref in __computed_refs__:
		ref.value_updated.connect(__computed_callable__)
	set_value(_callable.call(__computed_refs__))
	pass
