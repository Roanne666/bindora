extends Control

@onready var text_label: Label = $TextLabel
@onready var text_edit: TextEdit = $TextEdit
@onready var button_label: Label = $ButtonLabel
@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var slider_label: Label = $Slider/SliderLabel
@onready var max_value_slider: HSlider = $Slider/MaxValueSlider
@onready var color_rect: ColorRect = $Slider/ColorRect
@onready var width_slider: HSlider = $Slider/WidthSlider
@onready var height_slider: HSlider = $Slider/HeightSlider
@onready var check_button: CheckButton = $CheckButton
@onready var check_button_2: CheckButton = $CheckButton2
@onready var times_button: Button = $TimesButton
@onready var mouse_position_label: Label = $MousePositionLabel
@onready var background: ColorRect = $Background
@onready var color_picker_button: ColorPickerButton = $ColorPickerButton

@export var text_ref := RefString.new("test")
var click_ref := RefInt.new()
@export var max_value_ref := RefFloat.new(100.0)
var size_ref := RefVector2.new(Vector2(100.0, 100.0))
var disabled_ref := RefBool.new()
var custom_ref := RefInt.new()
var mouse_ref := RefVector2.new()
@export var color_ref := RefColor.new()


func _ready() -> void:
	# Edit binding.
	text_ref.bind_text(text_label)
	text_ref.bind_input(text_edit)

	# Binding with native handle.
	click_ref.bind_text(button_label)
	for i in h_box_container.get_child_count():
		var button = h_box_container.get_child(i) as Button
		button.pressed.connect(func(): click_ref.value=i + 1)

	# Nest binding.
	max_value_ref.bind_text(slider_label)
	max_value_ref.bind_input(max_value_slider)
	max_value_ref.bind_multi_property({width_slider: "max_value", height_slider: "max_value"})
	size_ref.bind_property(color_rect, "size")
	size_ref.bind_multi_input({width_slider: "x", height_slider: "y"})

	# Toggle binding.
	disabled_ref.bind_multi_toggle({check_button: false, check_button_2: false})
	disabled_ref.bind_property(times_button, "disabled")

	# Custom binding, watcher and show binding.
	custom_ref.create_watcher(_create_watcher)
	custom_ref.bind_custom(times_button, _custom_bind)
	custom_ref.bind_show(check_button_2, func(_value: int): return _value >= 5)
	times_button.pressed.connect(func(): custom_ref.value += 1)

	# Mouse tracking.
	mouse_ref.bind_text(mouse_position_label)

	# Shader binding.
	color_ref.bind_input(color_picker_button)
	color_ref.bind_shader(background, "color")
	pass


func _create_watcher(_watcher: SingleWatcher, _new_value: int) -> void:
	print("Click %d times." % _new_value)
	if _new_value >= 5:
		_watcher.destroy()


func _custom_bind(_node: Button, _refs: Array[Ref]) -> void:
	var times = custom_ref.value
	if times % 2 == 1:
		_node.text = "Click odd times"
	else:
		_node.text = "Click even times"
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_ref.value = event.position
	pass
