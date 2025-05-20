extends Label

func _ready() -> void:
	var ref = await Bindora.inject(self,"text") as RefString
	if ref :
		ref.bind_text(self)
	pass
