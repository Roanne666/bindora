extends Control


var text_ref := RefString.new("test")


func _ready() -> void:
	Bindora.provide(self, "text", text_ref)
	pass
