class_name PropertyBinding extends SingleRefBinding
## Property binding that synchronizes a node property with a reference value
##
## Binds a specific node property to a reference value, keeping them in sync.

## The name of the node property to bind
var __property__: String


func _init(
	_node: CanvasItem, _ref: RefVariant, _property: String, _use_node_data: bool = false
) -> void:
	super(_node, _ref)
	
	if not (_property in _node):
		push_error("PropertyBinding: Node '%s' missing property '%s'" % [_node.name, _property])
		return
		
	__property__ = _property
	if _use_node_data:
		__ref__.value = __node__.get(__property__)
	else:
		_update(null, __ref__.value)
	pass


func _update(_old_value, _new_value) -> void:
	if __node__.get(__property__) != _new_value:
		__node__.set(__property__, _new_value)
	pass
