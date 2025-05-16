# Bindora

[English](README.md) | 简体中文

Bindora 是一个用于 Godot 4.x 的响应式数据绑定库。它基于 Godot 的设计理念，提供了一种声明式和组件化的方式，帮助你处理节点和数据之间的关系。

## 核心功能

### 响应式数据系统
- 提供 [`Ref`](bindora/ref/ref.gd) 类作为基础数据类型
- 支持多种数据类型
- 支持序列化和反序列化
- 自动类型转换和检查
- 提供生命周期钩子
  
### 丰富的绑定支持
[`文本绑定`](bindora/binding/text_binding.gd)、[`输入绑定`](bindora/binding/input_binding.gd)、[`单选框绑定`](bindora/binding/radio_binding.gd)、[`复选框绑定`](bindora/binding/check_box_binding.gd)、[`属性绑定`](bindora/binding/property_binding.gd)、[`显示绑定`](bindora/binding/show_binding.gd)、[`着色器绑定`](bindora/binding/shader_binding.gd)、[`切换绑定`](bindora/binding/toggle_binding.gd)、[`列表绑定`](bindora/binding/list_binding.gd)、[`主题覆盖绑定`](bindora/binding/theme_override_binding.gd)、[`自定义绑定器`](bindora/binding/custom_binding.gd)
  
### 数据监控
- 提供 [`Watcher`](bindora/watcher/watcher.gd) 类进行数据监控
- 支持单值和多值监控
- 支持自定义回调函数

## 快速开始

### 安装 Bindora

将 `bindora` 文件夹复制到你的 Godot 项目中。

### 基础用法
创建一个 `Label` 节点，并将 `Label` 节点的 `text` 修改为 `"Text is {{value}}"`。然后为节点添加一个脚本，代码如下：
```gdscript
extends Label

# 声明数据并创建文本绑定
var text_ref = RefString.new("Hello World")
text_ref.bind_text(self)

# 创建观察者
text_ref.create_watcher(func(watcher,new_value):
    print("Text changed to: ", new_value)
)

await get_tree().create_timer(3.0).timeout

# 修改数据
text_ref.value = "New Text"
# 或者
text_ref.set_value("New Text") # 推荐使用 set_value 方法，因为它会检查类型
```
`Ref` 类中提供了非常多的快捷绑定方法，你可以在 [API 参考](#api-参考)中查看

### 使用 ReactiveResource
创建一个资源类，继承 `ReactiveResource`，然后在其中声明 `Ref` 变量。
> **注意**：在 `ReactiveResource` 中声明的 `Ref` 变量不需要通过 `@export` 导出，它们在声明时会被自动处理并导出，使用 `@export` 可能会引起未知错误。
```gdscript
class MyResource extends ReactiveResource:

var text_ref = RefString.new("Hello World")
```

结合 `RefArray` 使用。
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

`ReactiveResource` 类中提供了序列化和反序列化的功能，你可以使用 `to_dictionary` 将其转换为字典，或者使用 `from_dictionary` 从字典更新值。
```gdscript
var resource = MyResource.new()
var dict = resource.to_dictionary()
dict["text_ref"] = "New Text"
resource.from_dictionary(dict)
print(resource.text_ref.value) # New Text
```

`ReactiveResource` 类也提供了静态的序列化和反序列化方法，用法如下：
```gdscript
var resource = MyResource.new()
resource.text_ref.set_value("Hello World")
var dict = ReactiveResource.serialize(resource)
var new_resource = ReactiveResource.reactive(dict,MyResource)
print(new_resource.text_ref.value) # Hello World
```

### 更多使用方法
参考[`test`](test)文件夹中的例子

### 最佳实践

#### 类型选择
为数据选择合适的 `Ref` 类型，如 `RefString`、`RefInt` 等，避免直接使用 `Ref` 或其他基类来创建变量。

#### 修改和获取值
尽量避免使用 `.value` 来操作值，它在编辑器中是没有类型检查的，可能在运行中才会报错。而使用 `set_value()` 和 `get_value()` 函数则会在编辑器阶段就进行类型检查。

#### 绑定管理
`Binding` 会自动识别节点是否存在并清理，无需手动清理。而 `Watcher` 是不依赖于节点的，需要手动判断并清理。

#### 什么时候使用 `ReactiveResource`
对于大多数情况，直接使用 `Ref` 都能满足要求，但是在一些情况下使用 `ReactiveResource` 会表现得更好，以下为几个例子：
1. 在使用 `@export` 导出属性时，大量的 `Ref` 会使检查器变得复杂且不直观（因为导出的属性会包装一层），而 `ReactiveResource` 的自动导出功能可以避免这种情况。
2. 对于需要序列化和反序列化的内容，`ReactiveResource` 可以使用自带函数直接转化，不需要额外操作。

## API 参考

### 基础变量类型 - [`RefVariant`](bindora/ref/ref_variant.gd)
[`RefBool`](bindora/ref/ref_variant/ref_bool.gd)、[`RefInt`](bindora/ref/ref_variant/ref_int.gd)、[`RefFloat`](bindora/ref/ref_variant/ref_float.gd)、[`RefString`](bindora/ref/ref_variant/ref_string.gd)、[`RefVector2`](bindora/ref/ref_variant/ref_vector2.gd)、[`RefVector2i`](bindora/ref/ref_variant/ref_vector2i.gd)、[`RefVector3`](bindora/ref/ref_variant/ref_vector3.gd)、[`RefVector3i`](bindora/ref/ref_variant/ref_vector3i.gd)、[`RefVector4`](bindora/ref/ref_variant/ref_vector4.gd)、[`RefVector4i`](bindora/ref/ref_variant/ref_vector4i.gd)、[`RefRect2`](bindora/ref/ref_variant/ref_rect2.gd)、[`RefRect2i`](bindora/ref/ref_variant/ref_rect2i.gd)、[`RefColor`](bindora/ref/ref_variant/ref_color.gd)

绑定方法：
- bind_text(_node: CanvasItem, _keyword: String = "value",_template: String = "") -> [TextBinding](bindora/binding/text_binding.gd)
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

### 特殊类型
[`RefArray`](bindora/ref/ref_special/ref_array.gd)
- bind_text(_node: CanvasItem, _keyword: String = "value", _template: String = "") -> [TextBinding](bindora/binding/text_binding.gd) 
- bind_check_boxes(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, [CheckBoxBinding](bindora/binding/check_box_binding.gd)]
- bind_check_boxes_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, [CheckBoxBinding](bindora/binding/check_box_binding.gd)]
- bind_list(_parent: Node, _packed_scene: PackedScene, _callable: Callable) -> [ListBinding](bindora/binding/list_binding.gd)

[`RefDictionary`](bindora/ref/ref_special/ref_dictionary.gd)
- bind_text(_node: CanvasItem, _template: String = "") -> [TextBinding](bindora/binding/text_binding.gd)

### 资源类型 - [`RefResource`](bindora/ref/ref_resource.gd)
[`RefFont`](bindora/ref/ref_resource/ref_font.gd), [`RefLabelSettings`](bindora/ref/ref_resource/ref_label_settings.gd), [`RefMaterial`](bindora/ref/ref_resource/ref_material.gd), [`RefStyleBox`](bindora/ref/ref_resource/ref_style_box.gd), [`RefTexture`](bindora/ref/ref_resource/ref_texture.gd)

## 贡献

如果您遇到任何问题或有改进建议，请随时提出问题或提交拉取请求。

## 许可证

Bindora 是 MIT 许可证的开源项目。