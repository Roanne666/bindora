class_name PropertyBinding extends SingleRefBinding
## Property binding that synchronizes a node property with a reference value
##
## Binds a specific node property to a reference value, keeping them in sync.

## The name of the node property to bind
var property: String


func _init(
	_node: CanvasItem, _ref: RefVariant, _property: String, _use_node_data: bool = false
) -> void:
	super(_node, _ref)
	if not (_property in _node):
		push_error("Node doesn't have property '%s'" % _property)
	property = _property
	if _use_node_data:
		ref.value = node.get(property)
	else:
		update(ref.value)
	pass


func update(_value: Variant) -> void:
	if node.get(property) != _value:
		node.set(property, _value)
	pass
