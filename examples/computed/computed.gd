extends Control

var ref_1 := RefBool.new()
var ref_2 := RefInt.new(1000)

var computed_ref := RefString.new("abc")

@onready var label: Label = $Label

func _ready() -> void:
	computed_ref.as_computed([ref_1, ref_2], _computed)
	computed_ref.bind_text(label)

	await get_tree().create_timer(3.0).timeout

	ref_1.set_value(true)

func _computed(_refs: Array[Ref]) -> String:
	if ref_1.get_value() == true:
		return "true"
	else:
		return "%d" % ref_2.get_value()
