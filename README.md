# Bindora

English | [简体中文](README.zh_cn.md)

> [!NOTE]
> Bindora is currently in the development stage and the API is subject to change, so please use it with caution.

Bindora is a reactive data binding library for Godot 4.x. Based on Godot's design philosophy, it provides a declarative and component-based approach to help you manage relationships between nodes and data.

## Core Features

### Reactive Data System
- Provide the [`Ref`](addons/bindora/ref/ref.gd) class as the foundation for various data types
- Supports serialization and deserialization
- Automatic type conversion and checking
- Provides `signal` for data monitoring

### Comprehensive Binding Support
[`TextBinding`](addons/bindora/binding/dict_ref_binding/text_binding.gd)、[`InputBinding`](addons/bindora/binding/single_ref_binding/input_binding.gd)、[`RadioBinding`](addons/bindora/binding/single_ref_binding/radio_binding.gd)、[`CheckBoxBinding`](addons/bindora/binding/single_ref_binding/check_box_binding.gd)、[`PropertyBinding`](addons/bindora/binding/single_ref_binding/property_binding.gd)、[`VisibleBinding`](addons/bindora/binding/single_ref_binding/visible_binding.gd)、[`ShaderBinding`](addons/bindora/binding/dict_ref_binding/shader_binding.gd)、[`ToggleBinding`](addons/bindora/binding/single_ref_binding/toggle_binding.gd)、[`ListBinding`](addons/bindora/binding/single_ref_binding/list_binding.gd)、[`ThemeOverrideBinding`](addons/bindora/binding/single_ref_binding/theme_override_binding.gd)、[`CustomBinding`](addons/bindora/binding/multi_ref_binding/custom_binding.gd)

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

### Using `ReactiveResource` and `ReactiveNode`

`ReactiveResource` and `ReactiveNode` are two reactive container classes that allow you to declare `Ref` variables within them and automatically expose the values of these variables in the editor.

> [!NOTE]
> `Ref` variables declared in these two classes do not need to be exported with `@export`. They are automatically handled and exported upon declaration. Using `@export` may cause unexpected errors.

#### Differences Between Them

- **`ReactiveResource`**: Inherits from `Resource`, suitable for data resources. Can be saved as resource files, ideal for configuration data, game data, and other scenarios that require persistence. Provides static methods `serialize()` and `reactive()` for serialization and deserialization.
- **`ReactiveNode`**: Inherits from `Node`, suitable for scene nodes. Can be used directly in the scene tree, ideal for reactive components that require node functionality.

#### Basic Usage

**Using `ReactiveResource`:**
```gdscript
class MyResource extends ReactiveResource
    var text_ref = RefString.new("Hello World")
    var number_ref = RefInt.new(1)
```

**Using `ReactiveNode`:**
```gdscript
@tool
class_name WeaponNode
extends ReactiveNode

var text_ref := RefString.new("")
var damage_ref := RefInt.new(10)

@onready var label: Label = $Label

func _ready() -> void:
    if Engine.is_editor_hint():
        return
    text_ref.bind_text(label)
```

#### Serialization and Deserialization

Both provide `to_dictionary()` and `from_dictionary()` methods:

```gdscript
# ReactiveResource example
var resource = MyResource.new()
var dict = resource.to_dictionary()
dict["text_ref"] = "New Text"
resource.from_dictionary(dict)
print(resource.text_ref.value) # New Text

# ReactiveNode example
extends Control

@export var weapon_node: WeaponNode

func _ready() -> void:
    var dict = weapon_node.to_dictionary()
    dict["text_ref"] = "New Weapon Name"
    weapon_node.from_dictionary(dict)
    print(weapon_node.text_ref.value) # New Weapon Name
```

#### Using with `RefArray`

`ReactiveResource` is particularly suitable for use with `RefArray`:

```gdscript
var packed_scene = preload("res://path/to/your/packed_scene.tscn")
var array = RefArray.new()

array.bind_list($Container, packed_scene, func(item, data, index):
    data.text_ref.bind_text(item)
)

for i in 3:
    var new_item = MyResource.new()
    new_item.text_ref.set_value("Item " + str(i))
    array.append(new_item)
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
Refer to the examples in the [`examples`](examples) folder.

## Best Practices

### Type Selection
Choose appropriate `Ref` types for your data, such as `RefString` , `RefInt` , etc. Avoid directly using `Ref` or other base classes to create variables.

### Modifying and Getting Values
Try to avoid using `.value` to manipulate values, as it lacks type checking in the editor and may only report errors during runtime. Instead, use `set_value()` and `get_value()` functions which perform type checking at the editor stage.

### Binding Management
`Binding` will automatically recognize whether the node exists and recycle it. If you need to manually recycle it, you can use the `_dispose()` method.

### When to Use `ReactiveResource` and `ReactiveNode`

For most cases, using `Ref` will suffice. However, in some cases, using `ReactiveResource` or `ReactiveNode` can provide better performance.

**Scenarios for using `ReactiveResource`:**
1. Data that needs to be saved and loaded as resource files (such as configuration, game data, etc.)
2. Data structures that need to be used with `RefArray`
3. Scenarios that require static serialization methods to create new instances
4. When you want to use `RefDictionary`, you can use `ReactiveResource` instead, as it provides better type checking and autocomplete

**Scenarios for using `ReactiveNode`:**
1. Reactive components that need to be used directly in the scene tree
2. Reactive classes that require node functionality (such as `_ready()`, `_process()`, etc.)
3. Scenarios that require directly editing node properties in the editor

**Common advantages:**
1. When using `@export` to export properties, numerous `Ref` properties can make the inspector complex and unintuitive (because exported properties are wrapped). The automatic export feature of these two classes can avoid this situation.
2. For content that needs serialization and deserialization, you can use built-in functions to directly transform them without additional operations.

```gdscript
# Recommended - ReactiveResource (for data resources)
class MyResource extends ReactiveResource
    var text_ref = RefString.new("Hello World")
    var number_ref = RefInt.new(1)

# Recommended - ReactiveNode (for scene nodes)
class MyNode extends ReactiveNode
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

### Basic Variable Types - [`RefVariant`](addons/bindora/ref/ref_variant.gd)
[`RefBool`](addons/bindora/ref/ref_variant/ref_bool.gd), [`RefInt`](addons/bindora/ref/ref_variant/ref_int.gd), [`RefFloat`](addons/bindora/ref/ref_variant/ref_float.gd), [`RefString`](addons/bindora/ref/ref_variant/ref_string.gd), [`RefVector2`](addons/bindora/ref/ref_variant/ref_vector2.gd), [`RefVector2i`](addons/bindora/ref/ref_variant/ref_vector2i.gd), [`RefVector3`](addons/bindora/ref/ref_variant/ref_vector3.gd), [`RefVector3i`](addons/bindora/ref/ref_variant/ref_vector3i.gd), [`RefVector4`](addons/bindora/ref/ref_variant/ref_vector4.gd), [`RefVector4i`](addons/bindora/ref/ref_variant/ref_vector4i.gd), [`RefRect2`](addons/bindora/ref/ref_variant/ref_rect2.gd), [`RefRect2i`](addons/bindora/ref/ref_variant/ref_rect2i.gd), [`RefColor`](addons/bindora/ref/ref_variant/ref_color.gd)

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
[`RefArray`](addons/bindora/ref/ref_special/ref_array.gd)
- bind_text(_node: CanvasItem, _keyword: String = "value", _template: String = "") -> TextBinding
- bind_check_boxes(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, CheckBoxBinding]
- bind_check_boxes_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, CheckBoxBinding]
- bind_list(_parent: Node, _packed_scene: PackedScene, _callable: Callable) -> ListBinding

[`RefDictionary`](addons/bindora/ref/ref_special/ref_dictionary.gd)
- bind_text(_node: CanvasItem, _template: String = "") -> TextBinding

### Resource Types - [`RefResource`](addons/bindora/ref/ref_resource.gd)
[`RefFont`](addons/bindora/ref/ref_resource/ref_font.gd), [`RefLabelSettings`](addons/bindora/ref/ref_resource/ref_label_settings.gd), [`RefMaterial`](addons/bindora/ref/ref_resource/ref_material.gd), [`RefStyleBox`](addons/bindora/ref/ref_resource/ref_style_box.gd), [`RefTexture`](addons/bindora/ref/ref_resource/ref_texture.gd)

## Contributing

If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

Bindora is an open-source project under the MIT license.
