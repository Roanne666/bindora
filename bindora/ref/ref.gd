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

#region Lifecycle Hooks
## Callback invoked before value updates
var before_update: Callable

## Callback invoked after value updates
var on_updated: Callable

## Callback invoked before destruction
var before_destroy: Callable

## Callback invoked after destruction
var on_destroyed: Callable
#endregion

## Array of active bindings
var bindings: Array[Binding] = []

## Array of active watchers
var watchers: Array[Watcher] = []


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
	var fixed_new_value = _new_value
	if type == TYPE_DICTIONARY:
		var ref_dict: Dictionary[String, Ref] = {}
		for k in _new_value:
			var new_ref = Ref.new()
			new_ref.value = _new_value[k]
			ref_dict[k] = new_ref
		fixed_new_value = ref_dict
		value = ref_dict
	elif type == TYPE_ARRAY:
		fixed_new_value = _new_value.map(func(v: Variant): var ref = Ref.new(); ref.value = v; return ref)
	else:
		fixed_new_value = type_convert(_new_value, type)
		
	value_updated.emit(value, fixed_new_value)
	value = fixed_new_value
	_update()
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


## Adds a binding to this reference
func add_binding(_binding: Binding) -> void:
	bindings.append(_binding)
	pass


## Adds multiple bindings to this reference
func add_bindings(_bindings: Array[Binding]) -> void:
	bindings.append_array(_bindings)
	pass


## Removes a binding from this reference
func remove_binding(_binding: Binding) -> void:
	bindings.erase(_binding)
	pass


## Removes all bindings from this reference
func remove_all_bindings() -> void:
	bindings.clear()
	pass


## Creates a [SingleWatcher] for this reference
func create_watcher(_callable: Callable) -> SingleWatcher:
	return SingleWatcher.new(self, _callable)


## Adds a watcher to this reference
func add_watcher(_watcher: Watcher) -> void:
	watchers.append(_watcher)
	pass


## Adds multiple watchers to this reference
func add_watchers(_watchers: Array[Watcher]) -> void:
	watchers.append_array(_watchers)
	pass


## Removes a watcher from this reference
func remove_watcher(_watcher: Watcher) -> void:
	watchers.erase(_watcher)
	pass


## Removes all watchers from this reference
func remove_all_watchers() -> void:
	watchers.clear()
	pass


## Internal method to update all bindings and _watchers
func _update() -> void:
	if before_update:
		before_update.call(value)

	# Remove invalid bindings.
	for b in bindings:
		if b == null:
			bindings.erase(b)
		elif b.node == null:
			bindings.erase(b)
			b.destroy()

	# Update watchers.
	for w in watchers:
		w.update()

	# Update bindings.
	for b in bindings:
		b.update(value)

	if on_updated:
		on_updated.call(value)
	pass

## Cleans up the reference and all its dependencies
func destroy() -> void:
	if before_destroy:
		before_destroy.call(value)

	for w in watchers:
		w.destroy()
	for b in bindings:
		b.destroy()

	if on_destroyed:
		on_destroyed.call(value)
	pass
