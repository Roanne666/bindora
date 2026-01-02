@tool
class_name RefVariant extends Ref


## Quick method for [TextBinding]. (Single ref)
func bind_text(_node: CanvasItem, _keyword: String = "value", _template: String = "") -> TextBinding:
	return TextBinding.new(_node, {_keyword: self}, _template)


## Quick method for [InputBinding].
func bind_input(_node: CanvasItem, _property: String = "") -> InputBinding:
	return InputBinding.new(_node, self, _property)


## Quick method for [InputBinding]. (Multi nodes)
func bind_multi_input(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, InputBinding]:
	var binding_dict: Dictionary[CanvasItem, InputBinding] = {}
	for k in _dict:
		binding_dict[k] = InputBinding.new(k, self, _dict[k])
	return binding_dict


## Quick method for [PropertyBinding].
func bind_property(_node: CanvasItem, _property: String, _use_node_data: bool = false) -> PropertyBinding:
	return PropertyBinding.new(_node, self, _property, _use_node_data)


## Quick method for [PropertyBinding]. (Multi nodes)
func bind_multi_property(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, PropertyBinding]:
	var binding_dict: Dictionary[CanvasItem, PropertyBinding] = {}
	for k in _dict:
		binding_dict[k] = PropertyBinding.new(k, self, _dict[k])
	return binding_dict


## Quick method for [RadioBinding], uses radio's text as value.
func bind_radios(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, RadioBinding]:
	var binding_dict: Dictionary[CanvasItem, RadioBinding] = {}
	for n in _nodes:
		binding_dict[n] = RadioBinding.new(n, self, n["text"])
	return binding_dict


## Quick method for [RadioBinding], use custom text as value.
func bind_radios_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, RadioBinding]:
	var binding_dict: Dictionary[CanvasItem, RadioBinding] = {}
	for k in _dict:
		binding_dict[k] = RadioBinding.new(k, self, _dict[k])
	return binding_dict


## Quick method for [ShaderBinding].
func bind_shader(_node: CanvasItem, _property: String) -> ShaderBinding:
	return ShaderBinding.new(_node, {_property: self})


## Quick method for [VisibleBinding].
func bind_visible(_node: CanvasItem, _condition) -> VisibleBinding:
	return VisibleBinding.new(_node, self, _condition)


## Quick method for [ThemeOverrideBinding].
func bind_theme_override(_node: CanvasItem, _property: String) -> ThemeOverrideBinding:
	return ThemeOverrideBinding.new(_node, self, _property)


## Quick method for [ToggleBinding].
func bind_toggle(_node: CanvasItem, _opposite: bool = false) -> ToggleBinding:
	return ToggleBinding.new(_node, self, _opposite)


## Quick method for [ToggleBinding]. (Multi nodes)
func bind_multi_toggle(_dict: Dictionary[CanvasItem, bool]) -> Dictionary[CanvasItem, ToggleBinding]:
	var binding_dict: Dictionary[CanvasItem, ToggleBinding] = {}
	for k in _dict:
		binding_dict[k] = ToggleBinding.new(k, self, _dict[k])
	return binding_dict
