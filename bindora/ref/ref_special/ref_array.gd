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


func reverse() -> void:
	value.reverse()
	value_updated.emit(-1, value)
	pass


func sort() -> void:
	value.sort()
	value_updated.emit(-1, value)
	pass


func sort_custom(_callable: Callable) -> void:
	value.sort_custom(_callable)
	value_updated.emit(-1, value)
	pass


func shuffle() -> void:
	value.shuffle()
	value_updated.emit(-1, value)
	pass


func size() -> int:
	return value.size()


#endregion
