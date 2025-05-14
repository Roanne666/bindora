# Bindora

[English](README.md)/[中文](README.zh_cn.md)

Bindora 是一个用于 Godot 4.x 的响应式数据绑定库。它基于 Godot 的设计理念，提供了一种声明式和组件化的方式，帮助你处理节点和数据之间的关系。

## 核心功能

### 响应式数据系统
- 提供 [`Ref`](bindora/ref/ref.gd) 类作为基础数据类型
- 支持多种数据类型
- 支持序列化和反序列化
- 自动类型转换和检查
- 提供生命周期钩子
  
### 丰富的绑定支持
- 文本绑定 - [`TextBinding`](bindora/binding/text_binding.gd)
- 输入框绑定 - [`InputBinding`](bindora/binding/input_binding.gd)
- 单选框绑定 - [`RadioBinding`](bindora/binding/radio_binding.gd)
- 复选框绑定 - [`CheckBoxBinding`](bindora/binding/check_box_binding.gd)
- 属性绑定 - [`PropertyBinding`](bindora/binding/property_binding.gd)
- 显示绑定 - [`ShowBinding`](bindora/binding/show_binding.gd)
- 着色器绑定 - [`ShaderBinding`](bindora/binding/shader_binding.gd)
- 切换绑定 - [`ToggleBinding`](bindora/binding/toggle_binding.gd)
- 列表绑定 - [`ListBinding`](bindora/binding/list_binding.gd)
- 主题覆盖绑定 - [`ThemeOverrideBinding`](bindora/binding/theme_override_binding.gd)
- 自定义绑定器 - [`CustomBinding`](bindora/binding/custom_binding.gd)
  
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

# 声明数据
var text_ref = RefString.new("Hello World")

# 创建文本绑定
text_ref.bind_text(self)

# 创建观察者
text_ref.create_watcher(func(watcher,new_value):
    print("Text changed to: ", new_value)
)

# 等待一段时间
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

## API 参考

### 基础变量类型 - [`RefVariant`](bindora/ref/ref_variant/ref_variant.gd)
[`RefBool`](bindora/ref/ref_variant/ref_bool.gd)、[`RefInt`](bindora/ref/ref_variant/ref_int.gd)、[`RefFloat`](bindora/ref/ref_variant/ref_float.gd)、[`RefString`](bindora/ref/ref_variant/ref_string.gd)、[`RefVector2`](bindora/ref/ref_variant/ref_vector2.gd)、[`RefVector2i`](bindora/ref/ref_variant/ref_vector2i.gd)、[`RefVector3`](bindora/ref/ref_variant/ref_vector3.gd)、[`RefVector3i`](bindora/ref/ref_variant/ref_vector3i.gd)、[`RefVector4`](bindora/ref/ref_variant/ref_vector4.gd)、[`RefVector4i`](bindora/ref/ref_variant/ref_vector4i.gd)、[`RefRect2`](bindora/ref/ref_variant/ref_rect2.gd)、[`RefRect2i`](bindora/ref/ref_variant/ref_rect2i.gd)、[`RefColor`](bindora/ref/ref_variant/ref_color.gd)

绑定方法：
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

### 特殊类型
[`RefArray`](/bindora/ref/ref_special/ref_array.gd)
- bind_text(_node: CanvasItem, _keyword: String = "value", _template: String = "") -> [TextBinding](bindora/binding/text_binding.gd) 
- bind_check_boxes(_nodes: Array[CanvasItem]) -> Dictionary[CanvasItem, [CheckBoxBinding](bindora/binding/check_box_binding.gd)]
- bind_check_boxes_custom(_dict: Dictionary[CanvasItem, String]) -> Dictionary[CanvasItem, [CheckBoxBinding](bindora/binding/check_box_binding.gd)]
- bind_list(_parent: Node, _packed_scene: PackedScene, _callable: Callable) -> [ListBinding](bindora/binding/list_binding.gd)

[`RefDictionary`](/bindora/ref/ref_special/ref_dictionary.gd)
- bind_text(_node: CanvasItem, _template: String = "") -> [TextBinding](bindora/binding/text_binding.gd)

### 资源类型 - [`RefResource`](bindora/ref/ref_resource/ref_resource.gd)
- `RefFont`
- `RefLabelSettings`
- `RefMaterial`
- `RefStyleBox`

## 贡献

如果您发现任何问题或有改进建议，请随时提出问题或提交拉取请求。

## 许可证

Bindora 是 MIT 许可证的开源项目。