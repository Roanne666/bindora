# Bindora

English | [简体中文](README.zh_cn.md)

> [!NOTE]
> Bindora is currently in the development stage and the API is subject to change, so please use it with caution.

Bindora is a reactive data binding library for Godot 4.4. Based on Godot's design philosophy, it provides a declarative and component-based approach to help you manage relationships between nodes and data.

## Core Features

### Reactive Data System
- Provide the [`Ref`](bindora/ref/ref.gd) class as the foundation for various data types
- Supports serialization and deserialization
- Automatic type conversion and checking
- Provides `signal` for data monitoring

### Comprehensive Binding Support
[`TextBinding`](bindora/binding/dict_ref_binding/text_binding.gd)、[`InputBinding`](bindora/binding/single_ref_binding/input_binding.gd)、[`RadioBinding`](bindora/binding/single_ref_binding/radio_binding.gd)、[`CheckBoxBinding`](bindora/binding/single_ref_binding/check_box_binding.gd)、[`PropertyBinding`](bindora/binding/single_ref_binding/property_binding.gd)、[`VisibleBinding`](bindora/binding/single_ref_binding/visible_binding.gd)、[`ShaderBinding`](bindora/binding/dict_ref_binding/shader_binding.gd)、[`ToggleBinding`](bindora/binding/single_ref_binding/toggle_binding.gd)、[`ListBinding`](bindora/binding/single_ref_binding/list_binding.gd)、[`ThemeOverrideBinding`](bindora/binding/single_ref_binding/theme_override_binding.gd)、[`CustomBinding`](bindora/binding/multi_ref_binding/custom_binding.gd)

## Quick Start

### Installing Bindora

Copy the `bindora` folder into your Godot project.

### Basic Usage
Create a `Label` node and set its `text` to `"Text is {{value}}"`. Then add a script to the node with the following code:
```gdscript
extends Label

# Declare data
var text_ref = RefString.new("Hello World")

# Create text binding
text_ref.bind_text(self)

# Create a watcher
text_ref.value_updated.connect(func(old_value,new_value):
    print("Text changed to: ", new_value)
)

# Modify data
text_ref.value = "New Text"
# Or
text_ref.set_value("New Text") # Using set_value is recommended as it includes type checking
```
The `Ref` class provides many convenient binding methods, which you can explore in the [API Reference](#api-reference).

### Using `Binding`
When you need more complex data binding, you can directly use `Binding` .

```gdscript
extends Label

var text_ref = RefString.new("Hello")
var text_ref2 = RefString.new("World")

func _ready():->void:
    var binding = TextBinding.new(self, {"value": text_ref, "value2": text_ref2}, "Text is {{value}} {{value2}}")
```

### Using `ReactiveResource`

Create a resource class that extends `ReactiveResource` and declare `Ref` variables within it.

> [!NOTE]
> `Ref` variables declared in `ReactiveResource` do not need to be exported with `@export`. They are automatically handled and exported upon declaration. Using `@export` may cause unexpected errors.
```gdscript
class MyResource extends ReactiveResource
    var text_ref = RefString.new("Hello World")
```

Using with `RefArray`.
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

The `ReactiveResource` class provides serialization and deserialization functionality. You can use `to_dictionary` to convert it to a dictionary, or use `from_dictionary` to update values from a dictionary.
```gdscript
var resource = MyResource.new()
var dict = resource.to_dictionary()
dict["text_ref"] = "New Text"
resource.from_dictionary(dict)
print(resource.text_ref.value) # New Text
```

The `ReactiveResource` class also provides static serialization and deserialization methods, which can be used as follows:
```gdscript
var resource = MyResource.new()
resource.text_ref.set_value("Hello World")
var dict = ReactiveResource.serialize(resource)
var new_resource = ReactiveResource.reactive(dict,MyResource)
print(new_resource.text_ref.value) # Hello World
```

### More Usage Examples  
Refer to the examples in the [`test`](test) folder.

## Best Practices 

### Type Selection
Choose appropriate `Ref` types for your data, such as `RefString` , `RefInt` , etc. Avoid directly using `Ref` or other base classes to create variables.

### Modifying and Getting Values
Try to avoid using `.value` to manipulate values, as it lacks type checking in the editor and may only report errors during runtime. Instead, use `set_value()` and `get_value()` functions which perform type checking at the editor stage.

### Binding Management
`Binding` will automatically recognize whether the node exists and recycle it. If you need to manually recycle it, you can use the `destroy()` method.

### When to Use `ReactiveResource`
For most cases, using `Ref` will suffice. However, in some cases, using `ReactiveResource` can provide better performance. Here are a few examples:
1. When using `@export` to export properties, numerous `Ref` properties can make the inspector complex and unintuitive (because exported properties are wrapped). `ReactiveResource` 's automatic export feature can avoid this situation.
2. For content that needs serialization and deserialization, `ReactiveResource` can be transformed directly using built-in functions without additional operations.
3. When you want to use `RefDictionary`, you can use `ReactiveResource` instead, as it provides better type checking and autocomplete.

```gdscript
# Recommended
class MyResource extends ReactiveResource
    var text_ref = RefString.new("Hello World")
    var number_ref = RefInt.new(1)

# Optional
class MyResource extends Resource
    @export var text_ref = RefString.new("Hello World")
    @export var number_ref = RefInt.new(1)

# Not recommended
extends Node
    var dict_ref = RefDictionary.new({"text": "Hello World", "number": 1})
```

## API Reference

### Basic Variable Types - [`RefVariant`](bindora/ref/ref_variant.gd)
[`RefBool`](bindora/ref/ref_variant/ref_bool.gd), [`RefInt`](bindora/ref/ref_variant/ref_int.gd), [`RefFloat`](bindora/ref/ref_variant/ref_float.gd), [`RefString`](bindora/ref/ref_variant/ref_string.gd), [`RefVector2`](bindora/ref/ref_variant/ref_vector2.gd), [`RefVector2i`](bindora/ref/ref_variant/ref_vector2i.gd), [`RefVector3`](bindora/ref/ref_variant/ref_vector3.gd), [`RefVector3i`](bindora/ref/ref_variant/ref_vector3i.gd), [`RefVector4`](bindora/ref/ref_variant/ref_vector4.gd), [`RefVector4i`](bindora/ref/ref_variant/ref_vector4i.gd), [`RefRect2`](bindora/ref/ref_variant/ref_rect2.gd), [`RefRect2i`](bindora/ref/ref_variant/ref_rect2i.gd), [`RefColor`](bindora/ref/ref_variant/ref_color.gd)

Binding methods:
- bind_text(_node: CanvasItem, _keyword: String = "value",_template: String = "") -> TextBinding
- bind_input(_node: CanvasItem, _property: String = "") -> InputBinding
- bind_multi_input(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, InputBinding]
- bind_property(_node: CanvasItem, _property: String, _use_node_data: bool = false) -> PropertyBinding
- bind_multi_property(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, PropertyBinding]
- bind_radios(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, RadioBinding]
- bind_radios_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, RadioBinding]
- bind_shader(_node: CanvasItem, _property: String) -> ShaderBinding
- bind_visible(_node: CanvasItem, _condition: Callable | Ref) -> VisibleBinding
- bind_theme_override(_node: CanvasItem, _property: String) -> ThemeOverrideBinding
- bind_toggle(_node: CanvasItem, _opposite: bool = false) -> ToggleBinding
- bind_multi_toggle(_dict: Dictionary[CanvasItem, bool]) -> Dictionary[CanvasItem, ToggleBinding]
- bind_custom(_node: CanvasItem, _callable: Callable) -> CustomBinding

### Special Types
[`RefArray`](bindora/ref/ref_special/ref_array.gd)
- bind_text(_node: CanvasItem, _keyword: String = "value", _template: String = "") -> TextBinding
- bind_check_boxes(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, CheckBoxBinding]
- bind_check_boxes_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, CheckBoxBinding]
- bind_list(_parent: Node, _packed_scene: PackedScene, _callable: Callable) -> ListBinding

[`RefDictionary`](bindora/ref/ref_special/ref_dictionary.gd)
- bind_text(_node: CanvasItem, _template: String = "") -> TextBinding

### Resource Types - [`RefResource`](bindora/ref/ref_resource.gd)
[`RefFont`](bindora/ref/ref_resource/ref_font.gd), [`RefLabelSettings`](bindora/ref/ref_resource/ref_label_settings.gd), [`RefMaterial`](bindora/ref/ref_resource/ref_material.gd), [`RefStyleBox`](bindora/ref/ref_resource/ref_style_box.gd), [`RefTexture`](bindora/ref/ref_resource/ref_texture.gd)

## Contributing

If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

Bindora is an open-source project under the MIT license.