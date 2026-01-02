@tool
class_name RefArray extends Ref
## Array reference class, overrides most built-in array functions


func set_value(_value: Array) -> void:
	value = _value
	pass


func get_value() -> Array:
	return value


func _init(_value: Array = []) -> void:
	super(TYPE_ARRAY, _value)
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
## Signature: func _create_binding(_scene: Node, _data: Variant, _index: int) -> Array[Binding]: return []
func bind_list(_parent: Node, _packed_scene: PackedScene, _callable: Callable) -> ListBinding:
	return ListBinding.new(_parent, self, _packed_scene, _callable)


#endregion

func _insert_data(_position: int, _value) -> void:
	get_value().insert(_position, _value)
	value_updated.emit(_position, _value)
	pass


func _remove_data(_position: int) -> Variant:
	var data = value.pop_at(_position)
	value_updated.emit(_position, data)
	return data


#region Rewrite array function
func append(_value) -> void:
	_insert_data(get_value().size(), _value)
	pass


func erase(_value) -> void:
	var position = value.find(_value)
	if position > -1:
		_remove_data(position)
	pass


func push_back(_value) -> void:
	_insert_data(value.size(), _value)
	pass


func push_front(_value) -> void:
	_insert_data(0, _value)
	pass


func pop_back() -> Variant:
	return _remove_data(value.size() - 1)


func pop_front() -> Variant:
	return _remove_data(0)


func insert(_position: int, _value) -> void:
	_insert_data(_position, _value)
	pass


func remove_at(_position: int) -> void:
	_remove_data(_position)
	pass


func replace_at(_position: int, _value) -> void:
	value[_position] = _value
	value_updated.emit(_position, _value)
	pass


## Creates a mapping of old indices to new indices after array reordering
func _create_index_mapping(_old_value: Array, _new_value: Array) -> Dictionary:
	var index_mapping = {}
	var value_to_old_indices = {}

	for i in _old_value.size():
		var val = _old_value[i]
		if not value_to_old_indices.has(val):
			value_to_old_indices[val] = []
		value_to_old_indices[val].append(i)

	for new_index in _new_value.size():
		var val = _new_value[new_index]
		var old_indices = value_to_old_indices[val]
		var old_index = old_indices.pop_front()
		index_mapping[old_index] = new_index

	return index_mapping


func reverse() -> void:
	var value_size = value.size()
	var index_mapping = {}

	for i in value_size:
		index_mapping[i] = value_size - 1 - i

	value.reverse()
	value_updated.emit(-1, index_mapping)
	pass

func sort() -> void:
	var old_value = value.map(func(v): return v) as Array
	value.sort()
	var index_mapping = _create_index_mapping(old_value, value)
	value_updated.emit(-1, index_mapping)
	pass

func sort_custom(_callable: Callable) -> void:
	var old_value = value.map(func(v): return v) as Array
	value.sort_custom(_callable)
	var index_mapping = _create_index_mapping(old_value, value)
	value_updated.emit(-1, index_mapping)
	pass

func shuffle() -> void:
	var old_value = value.map(func(v): return v) as Array
	value.shuffle()
	var index_mapping = _create_index_mapping(old_value, value)
	value_updated.emit(-1, index_mapping)
	pass

func size() -> int:
	return value.size()


#endregion
