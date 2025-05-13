class_name MultiRefBinding extends Binding
## A binding that monitors multiple references simultaneously
##
## This binding reacts to changes in any of its watched references.
## Automatically manages binding registration with all provided references.

## Array of references being monitored by this binding
var refs: Array[Ref]


func _init(_node: CanvasItem, _refs: Array[Ref]) -> void:
	super(_node)
	refs = _refs
	for r in refs:
		r.add_binding(self)
	pass


func destroy() -> void:
	for ref in refs:
		ref.remove_binding(self)
	refs.clear()
	pass
