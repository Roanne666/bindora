class_name SingleRefBinding extends Binding

var ref: Ref
var __callable__ := _create_connect_callable()

func _init(_node: CanvasItem, _ref: Ref) -> void:
	super (_node)
	ref = _ref
	ref.value_updated.connect(__callable__)
	pass


func dispose() -> void:
	if ref == null:
		return
	ref.value_updated.disconnect(__callable__)
	ref = null
	pass
