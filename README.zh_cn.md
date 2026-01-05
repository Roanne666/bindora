# Bindora

[English](README.md) | 简体中文

> [!NOTE]
> Bindora 目前处于开发阶段，API 可能会发生变化，请谨慎使用。

Bindora 是一个用于 Godot 4.x 的响应式数据绑定库。它基于 Godot 的设计理念，提供了一种声明式和组件化的方式，帮助你处理节点和数据之间的关系。

## 核心功能

### 响应式数据系统
- 提供 [`Ref`](addons/bindora/ref/ref.gd) 类作为基础的多种数据类型
- 支持序列化和反序列化
- 自动类型转换和检查
- 以 `信号` 的方式进行数据监控

### 丰富的绑定支持
[`文本绑定`](addons/bindora/binding/dict_ref_binding/text_binding.gd)、[`输入绑定`](addons/bindora/binding/single_ref_binding/input_binding.gd)、[`单选框绑定`](addons/bindora/binding/single_ref_binding/radio_binding.gd)、[`复选框绑定`](addons/bindora/binding/single_ref_binding/check_box_binding.gd)、[`属性绑定`](addons/bindora/binding/single_ref_binding/property_binding.gd)、[`显示绑定`](addons/bindora/binding/single_ref_binding/visible_binding.gd)、[`着色器绑定`](addons/bindora/binding/dict_ref_binding/shader_binding.gd)、[`切换绑定`](addons/bindora/binding/single_ref_binding/toggle_binding.gd)、[`列表绑定`](addons/bindora/binding/single_ref_binding/list_binding.gd)、[`主题覆盖绑定`](addons/bindora/binding/single_ref_binding/theme_override_binding.gd)、[`自定义绑定器`](addons/bindora/binding/multi_ref_binding/custom_binding.gd)

## 快速开始

### 安装 Bindora

将 `bindora` 文件夹复制到你的 Godot 项目中。

### 基础用法
创建一个 `Label` 节点，并将 `Label` 节点的 `text` 修改为 `"Text is {{value}}"`。然后为节点添加一个脚本，代码如下：
```gdscript
extends Label

var text_ref = RefString.new("Hello World")

func _ready():->void:
    # 声明数据并创建文本绑定
    text_ref.bind_text(self)

    # 创建监听器
    text_ref.value_updated.connect(func(old_value,new_value):
        print("Text changed to: %s" % new_value)
    )

    # 修改数据
    text_ref.value = "New Text"
    # 或者
    text_ref.set_value("New Text") # 推荐使用 set_value 方法，因为它会检查类型
```
`Ref` 类中提供了非常多的快捷绑定方法，你可以在 [API 参考](#api-参考)中查看

### 使用 `Binding`
当你需要更复杂的数据绑定时，可以直接使用 `Binding` 。

```gdscript
extends Label

var text_ref = RefString.new("Hello")
var text_ref2 = RefString.new("World")

func _ready():->void:
    var binding = TextBinding.new(self, {"value": text_ref, "value2": text_ref2}, "Text is {{value}} {{value2}}")
```

### 使用 `ReactiveResource` 和 `ReactiveNode`

`ReactiveResource` 和 `ReactiveNode` 是两个响应式容器类，它们允许你在类中声明 `Ref` 变量，并自动在编辑器中暴露这些变量的值。

> [!NOTE]
> 在这两个类中声明的 `Ref` 变量不需要通过 `@export` 导出，它们在声明时会被自动处理并导出，使用 `@export` 可能会引起未知错误。

#### 两者的区别

- **`ReactiveResource`**：继承自 `Resource`，适用于数据资源。可以作为资源文件保存，适合用于配置数据、游戏数据等需要持久化的场景。提供了静态方法 `serialize()` 和 `reactive()` 用于序列化和反序列化。
- **`ReactiveNode`**：继承自 `Node`，适用于场景节点。可以直接在场景树中使用，适合用于需要节点功能的响应式组件。

#### 基础用法

**使用 `ReactiveResource`：**
```gdscript
class MyResource extends ReactiveResource
    var text_ref = RefString.new("Hello World")
    var number_ref = RefInt.new(1)
```

**使用 `ReactiveNode`：**
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

#### 序列化和反序列化

两者都提供了 `to_dictionary()` 和 `from_dictionary()` 方法：

```gdscript
# ReactiveResource 示例
var resource = MyResource.new()
var dict = resource.to_dictionary()
dict["text_ref"] = "New Text"
resource.from_dictionary(dict)
print(resource.text_ref.value) # New Text

# ReactiveNode 示例
extends Control

@export var weapon_node: WeaponNode

func _ready() -> void:
    var dict = weapon_node.to_dictionary()
    dict["text_ref"] = "New Weapon Name"
    weapon_node.from_dictionary(dict)
    print(weapon_node.text_ref.value) # New Weapon Name
```

#### 结合 `RefArray` 使用

`ReactiveResource` 特别适合与 `RefArray` 结合使用：

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

### 更多使用方法
参考[`examples`](examples)文件夹中的例子

## 最佳实践

### 类型选择
为数据选择合适的 `Ref` 类型，如 `RefString`、`RefInt` 等，避免直接使用 `Ref` 或其他基类来创建变量。

### 修改和获取值
尽量避免使用 `.value` 来操作值，它在编辑器中是没有类型检查的，可能在运行中才会报错。而使用 `set_value()` 和 `get_value()` 函数则会在编辑器阶段就进行类型检查。

### 绑定管理
`Binding` 会自动识别节点是否存在并回收。如果需要手动回收，可以使用 `_dispose()` 方法。

### 什么时候使用 `ReactiveResource` 和 `ReactiveNode`

对于大多数情况，只使用 `Ref` 就能满足要求，但是在一些情况下使用 `ReactiveResource` 或 `ReactiveNode` 会表现得更好。

**使用 `ReactiveResource` 的场景：**
1. 需要作为资源文件保存和加载的数据（如配置、游戏数据等）
2. 需要与 `RefArray` 结合使用的数据结构
3. 需要静态序列化方法创建新实例的场景
4. 当你想用 `RefDictionary` 时，可以使用 `ReactiveResource` 来替代，因为它可以提供更好的类型检查和自动补全

**使用 `ReactiveNode` 的场景：**
1. 需要在场景树中直接使用的响应式组件
2. 需要节点功能（如 `_ready()`、`_process()` 等）的响应式类
3. 需要在编辑器中直接编辑节点属性的场景

**共同优势：**
1. 在使用 `@export` 导出属性时，大量的 `Ref` 会使检查器变得复杂且不直观（因为导出的属性会包装一层），而这两个类的自动导出功能可以避免这种情况
2. 对于需要序列化和反序列化的内容，可以使用自带函数直接转化，不需要额外操作

```gdscript
# 推荐使用 - ReactiveResource（用于数据资源）
class MyResource extends ReactiveResource
    var text_ref = RefString.new("Hello World")
    var number_ref = RefInt.new(1)

# 推荐使用 - ReactiveNode（用于场景节点）
class MyNode extends ReactiveNode
    var text_ref = RefString.new("Hello World")
    var number_ref = RefInt.new(1)

# 可选用
class MyResource extends Resource
    @export var text_ref = RefString.new("Hello World")
    @export var number_ref = RefInt.new(1)

# 不推荐使用
extends Node
    var dict_ref = RefDictionary.new({"text": "Hello World", "number": 1})
```

## API 参考

### 基础变量类型 - [`RefVariant`](addons/bindora/ref/ref_variant.gd)
[`RefBool`](addons/bindora/ref/ref_variant/ref_bool.gd)、[`RefInt`](addons/bindora/ref/ref_variant/ref_int.gd)、[`RefFloat`](addons/bindora/ref/ref_variant/ref_float.gd)、[`RefString`](addons/bindora/ref/ref_variant/ref_string.gd)、[`RefVector2`](addons/bindora/ref/ref_variant/ref_vector2.gd)、[`RefVector2i`](addons/bindora/ref/ref_variant/ref_vector2i.gd)、[`RefVector3`](addons/bindora/ref/ref_variant/ref_vector3.gd)、[`RefVector3i`](addons/bindora/ref/ref_variant/ref_vector3i.gd)、[`RefVector4`](addons/bindora/ref/ref_variant/ref_vector4.gd)、[`RefVector4i`](addons/bindora/ref/ref_variant/ref_vector4i.gd)、[`RefRect2`](addons/bindora/ref/ref_variant/ref_rect2.gd)、[`RefRect2i`](addons/bindora/ref/ref_variant/ref_rect2i.gd)、[`RefColor`](addons/bindora/ref/ref_variant/ref_color.gd)

绑定方法：
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

### 特殊类型
[`RefArray`](addons/bindora/ref/ref_special/ref_array.gd)
- bind_text(_node: CanvasItem, _keyword: String = "value", _template: String = "") -> TextBinding
- bind_check_boxes(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, CheckBoxBinding]
- bind_check_boxes_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, CheckBoxBinding]
- bind_list(_parent: Node, _packed_scene: PackedScene, _callable: Callable) -> ListBinding

[`RefDictionary`](addons/bindora/ref/ref_special/ref_dictionary.gd)
- bind_text(_node: CanvasItem, _template: String = "") -> TextBinding

### 资源类型 - [`RefResource`](addons/bindora/ref/ref_resource.gd)
[`RefFont`](addons/bindora/ref/ref_resource/ref_font.gd), [`RefLabelSettings`](addons/bindora/ref/ref_resource/ref_label_settings.gd), [`RefMaterial`](addons/bindora/ref/ref_resource/ref_material.gd), [`RefStyleBox`](addons/bindora/ref/ref_resource/ref_style_box.gd), [`RefTexture`](addons/bindora/ref/ref_resource/ref_texture.gd)

## 贡献

如果您遇到任何问题或有改进建议，请随时提出问题或提交拉取请求。

## 许可证

Bindora 是 MIT 许可证的开源项目。