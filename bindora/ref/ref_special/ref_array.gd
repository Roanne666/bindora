@tool
class_name RefArray extends Ref
## Array reference class, overrides most built-in array functions

var force_refresh: bool = false
var _diff := -1


func set_value(_value: Array) -> void:
	value = _value
	pass


func get_value() -> Array[Ref]:
	return value


func _init(_value:=Array()) -> void:
	type = TYPE_ARRAY
	super (_value)
	pass


#region Bind methods
## Quick method for [TextBinding] (only for single ref)
func bind_text(_node: CanvasItem, _keyword: String = "value", _template: String = "") -> TextBinding:
	return TextBinding.new(_node, {_keyword: self}, _template)


## Quick method for [CheckBoxBinding], uses radio's text as value.
func bind_check_boxes(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, CheckBoxBinding]:
	var binding_dict: Dictionary[CanvasItem, CheckBoxBinding] = {}
	for n in _nodes:
		binding_dict[n] = CheckBoxBinding.new(n, self, n["text"])
	return binding_dict


## Quick method for [CheckBoxBinding], uses custom text as value.
func bind_check_boxes_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, CheckBoxBinding]:
	var binding_dict: Dictionary[CanvasItem, CheckBoxBinding] = {}
	for k in _dict:
		binding_dict[k] = CheckBoxBinding.new(k, self, _dict[k])
	return binding_dict


## Quick method for [ListBinding].
func bind_list(_parent: Node, _packed_scene: PackedScene, _callable: Callable) -> ListBinding:
	return ListBinding.new(_parent, self, _packed_scene, _callable)


#endregion

func _insert_data(_position: int, _value: Variant) -> void:
	value.insert(_position, _value)
	if not force_refresh:
		_diff = _position
	_update()
	pass


func _remove_data(_position: int) -> Variant:
	var data = value.pop_at(_position)
	if not force_refresh:
		_diff = _position
	_update()
	return data


#region Rewrite array function
func append(_value: Variant) -> void:
	_insert_data(value.size(), _value)
	pass


func erase(_value: Variant) -> void:
	value.erase(_value)
	_update()
	pass


func push_back(_value: Variant) -> void:
	_insert_data(value.size(), _value)
	pass


func push_front(_value: Variant) -> void:
	_insert_data(0, _value)
	pass


func pop_back() -> Variant:
	return _remove_data(value.size() - 1)


func pop_front() -> Variant:
	return _remove_data(0)


func insert(_position: int, _value: Variant) -> void:
	_insert_data(_position, _value)
	pass


func remove_at(_position: int) -> void:
	_remove_data(_position)
	pass


func reverse() -> void:
	value.reverse()
	_update()
	pass


func sort() -> void:
	value.sort()
	_update()
	pass


func sort_custom(_callable: Callable) -> void:
	value.sort_custom(_callable)
	_update()
	pass


func shuffle() -> void:
	value.shuffle()
	_update()
	pass


func size() -> int:
	return value.size()


#endregion


## Internal method to update all bindings and watchers
func _update() -> void:
	# Remove invalid bindings.
	var unuse_list: Array[int] = []
	for i in _bindings.size():
		var binding := _bindings[i]
		if binding.node == null:
			unuse_list.append(i)
	if unuse_list.size() > 0:
		unuse_list.reverse()
		for i in unuse_list:
			_bindings.remove_at(i)

	# Update watchers.
	for w in _watchers:
		w.update()

	# Update bindings.
	for b in _bindings:
		if b is ListBinding:
			b.update(_diff)
		else:
			b.update(value)

	# Update children ref's bindings.
	for d in value:
		if d is Ref:
			d.update()
		elif d is Object:
			_update_object(d)

	# Reset diff.
	_diff = -1
	pass


## Internal method to recursively update object properties
func _update_object(_object: Object) -> void:
	for d in _object.get_property_list():
		var object_value = _object.get(d["name"])
		if object_value is RefVariant:
			object_value._update()
		elif object_value is Object:
			_update_object(object_value)
	pass
