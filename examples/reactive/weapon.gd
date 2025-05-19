@tool
class_name WeaponNode extends ReactiveNode

var text_ref := RefString.new("")

@onready var label: Label = $Label

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	text_ref.bind_text(label)
