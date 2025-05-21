extends Control

const BASIC = preload("res://examples/basic/basic.tscn")

var current_scene:Node

@onready var button: Button = $Button


func _ready() -> void:
	button.pressed.connect(_change_scene)


func _change_scene()->void:
	if current_scene:
		current_scene.queue_free()
	current_scene = BASIC.instantiate()
	add_child(current_scene)
