# Bindora

[English](README.md)/[中文](README.zh_cn.md)

Bindora is a reactive data binding library for Godot 4.x. Based on Godot's design philosophy, it provides a declarative and component-based approach to help you manage relationships between nodes and data.

## Core Features

### Reactive Data System
- Provides the [`Ref`](bindora/ref/ref.gd) class as the base data type
- Supports multiple data types
- Supports serialization and deserialization
- Automatic type conversion and checking
- Provides lifecycle hooks

### Comprehensive Binding Support
- Text binding - [`TextBinding`](bindora/binding/text_binding.gd)
- Input binding - [`InputBinding`](bindora/binding/input_binding.gd)
- Radio button binding - [`RadioBinding`](bindora/binding/radio_binding.gd)
- Checkbox binding - [`CheckBoxBinding`](bindora/binding/check_box_binding.gd)
- Property binding - [`PropertyBinding`](bindora/binding/property_binding.gd)
- Display binding - [`ShowBinding`](bindora/binding/show_binding.gd)
- Shader binding - [`ShaderBinding`](bindora/binding/shader_binding.gd)
- Toggle binding - [`ToggleBinding`](bindora/binding/toggle_binding.gd)
- List binding - [`ListBinding`](bindora/binding/list_binding.gd)
- Theme override binding - [`ThemeOverrideBinding`](bindora/binding/theme_override_binding.gd)
- Custom binding - [`CustomBinding`](bindora/binding/custom_binding.gd)

### Data Monitoring
- Provides the [`Watcher`](bindora/watcher/watcher.gd) class for data monitoring
- Supports single and multi-value monitoring
- Supports custom callback functions

## Quick Start

### Installing Bindora

Copy the `addons/bindora` folder into your Godot project.

### Basic Usage
Create a `Label` node and set its `text` to `"Text is {{value}}"`. Then add a script to the node with the following code:
```gdscript
extends Label

# Declare data
var text_ref = RefString.new("Hello World")

# Create text binding
text_ref.bind_text(self)

# Create a watcher
text_ref.create_watcher(func(watcher,new_value):
	print("Text changed to: ", new_value)
)

# Wait for a while
await get_tree().create_timer(3.0).timeout

# Modify data
text_ref.value = "New Text"
# Or
text_ref.set_value("New Text") # Using set_value is recommended as it includes type checking
```
The `Ref` class provides many convenient binding methods, which you can explore in the [API Reference](#api-reference).

### Using ReactiveResource
Create a resource class that extends `ReactiveResource` and declare `Ref` variables within it.
> **Note**: `Ref` variables declared in `ReactiveResource` do not need to be exported with `@export`. They are automatically handled and exported upon declaration. Using `@export` may cause unexpected errors.
```gdscript
class MyResource extends ReactiveResource:

var text_ref = RefString.new("Hello World")
```

Using `RefArray` in combination.
```gdscript
var packed_scene = preload("res://path/to/your/packed_scene.tscn")
var array = RefArray.new()
array.bind_list($Container, packed_scene, func(item, data , index):
	data.text_ref.bind_text(item)
)
for i in 3:
	var new_item = MyResource.new()
	new_item.text_ref.set_value("Item " + i)
	array.append(new_item)
```

## API Reference

### Basic Variable Types - [`RefVariant`](bindora/ref/ref_variant/ref_variant.gd)
[`RefBool`](bindora/ref/ref_variant/ref_bool.gd), [`RefInt`](bindora/ref/ref_variant/ref_int.gd), [`RefFloat`](bindora/ref/ref_variant/ref_float.gd), [`RefString`](bindora/ref/ref_variant/ref_string.gd), [`RefVector2`](bindora/ref/ref_variant/ref_vector2.gd), [`RefVector2i`](bindora/ref/ref_variant/ref_vector2i.gd), [`RefVector3`](bindora/ref/ref_variant/ref_vector3.gd), [`RefVector3i`](bindora/ref/ref_variant/ref_vector3i.gd), [`RefVector4`](bindora/ref/ref_variant/ref_vector4.gd), [`RefVector4i`](bindora/ref/ref_variant/ref_vector4i.gd), [`RefRect2`](bindora/ref/ref_variant/ref_rect2.gd), [`RefRect2i`](bindora/ref/ref_variant/ref_rect2i.gd), [`RefColor`](bindora/ref/ref_variant/ref_color.gd)

Binding methods:
- bind_text(_node: CanvasItem, _property: String = "value",_template: String = "") -> [TextBinding](bindora/binding/text_binding.gd)
- bind_input(_node: CanvasItem, _property: String = "") -> [InputBinding](bindora/binding/input_binding.gd)
- bind_multi_input(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, [InputBinding](bindora/binding/input_binding.gd)]
- bind_property(_node: CanvasItem, _property: String, _use_node_data: bool = false) -> [PropertyBinding](bindora/binding/property_binding.gd)
- bind_multi_property(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, [PropertyBinding](bindora/binding/property_binding.gd)]
- bind_radios(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, [RadioBinding](bindora/binding/radio_binding.gd)]
- bind_radios_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, [RadioBinding](bindora/binding/radio_binding.gd)]
- bind_shader(_node: CanvasItem, _property: String) -> [ShaderBinding](bindora/binding/shader_binding.gd)
- bind_show(_node: CanvasItem, _callable: Callable) -> [ShowBinding](bindora/binding/show_binding.gd)
- bind_theme_override(_node: CanvasItem, _property: String) -> [ThemeOverrideBinding](bindora/binding/theme_override_binding.gd)
- bind_toggle(_node: CanvasItem, _opposite: bool = false) -> [ToggleBinding](bindora/binding/toggle_binding.gd)
- bind_multi_toggle(_dict: Dictionary[CanvasItem, bool]) -> Dictionary[CanvasItem, [ToggleBinding](bindora/binding/toggle_binding.gd)]

### Special Types
[`RefArray`](/bindora/ref/ref_special/ref_array.gd)
- bind_text(_node: CanvasItem, _keyword: String = "value", _template: String = "") -> [TextBinding](bindora/binding/text_binding.gd) 
- bind_check_boxes(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, [CheckBoxBinding](bindora/binding/check_box_binding.gd)]
- bind_check_boxes_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, [CheckBoxBinding](bindora/binding/check_box_binding.gd)]
- bind_list(_parent: Node, _packed_scene: PackedScene, _callable: Callable) -> [ListBinding](bindora/binding/list_binding.gd)

[`RefDictionary`](/bindora/ref/ref_special/ref_dictionary.gd)
- bind_text(_node: CanvasItem, _template: String = "") -> [TextBinding](bindora/binding/text_binding.gd)

### Resource Types - [`RefResource`](bindora/ref/ref_resource/ref_resource.gd)
- `RefFont`
- `RefLabelSettings`
- `RefMaterial`
- `RefStyleBox`

## Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

Bindora is an open-source project under the MIT license.