extends Control

var font_size := RefInt.new(24)
var font_color := RefColor.new()

@onready var label: Label = $Label
@onready var h_slider: HSlider = $HSlider
@onready var color_picker_button: ColorPickerButton = $ColorPickerButton


func _ready() -> void:
	font_size.bind_input(h_slider)
	font_size.bind_theme_override(label, "font_size")
	font_color.bind_input(color_picker_button)
	font_color.bind_theme_override(label, "font_color")
	pass
