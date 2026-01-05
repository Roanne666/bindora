extends Control

var radio_ref := RefString.new()
var check_box_ref := RefArray.new()

@onready var label: Label = $Label
@onready var radio: CheckBox = $Radio
@onready var radio_2: CheckBox = $Radio2
@onready var radio_3: CheckBox = $Radio3
@onready var label_2: Label = $Label2
@onready var check_box: CheckBox = $CheckBox
@onready var check_box_2: CheckBox = $CheckBox2
@onready var check_box_3: CheckBox = $CheckBox3


func _ready() -> void:
	radio_ref.bind_text(label)
	radio_ref.bind_radios([radio, radio_2, radio_3])

	check_box_ref.bind_text(label_2)
	check_box_ref.bind_check_boxes([check_box, check_box_2, check_box_3])

	check_box_ref.append("Apple")
	pass
