extends Control

const BASIC = preload("res://examples/basic/basic.tscn")

var current_scene: Node

@onready var button: Button = $Button


func _ready() -> void:
	button.pressed.connect(_change_scene)
	await get_tree().create_timer(2.0).timeout
	current_scene = BASIC.instantiate()
	add_child(current_scene)


func _change_scene() -> void:
	if current_scene:
		current_scene.queue_free()
		await get_tree().process_frame
	#current_scene = BASIC.instantiate()
	#add_child(current_scene)
