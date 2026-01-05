extends Node2D

var pos_ref := RefVector2.new()
var speed_ref := RefVector2.new()
var speed_value := 200

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	pos_ref.value = sprite_2d.position
	pos_ref.bind_property(sprite_2d, "position")
	pass


func _process(delta: float) -> void:
	pos_ref.value += speed_ref.value * delta


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_LEFT:
				speed_ref.value.x = -speed_value
			elif event.keycode == KEY_RIGHT:
				speed_ref.value.x = speed_value
			elif event.keycode == KEY_UP:
				speed_ref.value.y = -speed_value
			elif event.keycode == KEY_DOWN:
				speed_ref.value.y = speed_value
		else:
			if event.keycode == KEY_LEFT or event.keycode == KEY_RIGHT:
				speed_ref.value.x = 0
			elif event.keycode == KEY_UP or event.keycode == KEY_DOWN:
				speed_ref.value.y = 0
	pass
