extends Control

@export var item := ItemResource.new()

@onready var label: Label = $Label


func _ready() -> void:
	item.quantity.bind_text(label)
	var dict = item.to_dictionary()
	dict["quantity"] = 10000
	await get_tree().create_timer(2.0).timeout
	item.from_dictionary(dict)
