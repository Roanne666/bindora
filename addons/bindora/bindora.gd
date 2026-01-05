class_name Bindora
extends Object

static var __properties__: Array[Prop] = []


static func provide(_node: Node, _property: String, _ref: Ref) -> void:
	if not is_instance_valid(_node):
		push_error("Bindora.provide: Invalid node provided")
		return

	for prop in __properties__:
		if prop.node == _node and prop.name == _property:
			return
	__properties__.append(Prop.new(_node, _property, _ref))
	pass


static func _remove_prop(_prop: Prop) -> void:
	__properties__.erase(_prop)
	pass


static func inject(_node: Node, _property: String) -> Ref:
	if not is_instance_valid(_node):
		return null

	var window := _node.get_window()

	if not window.is_node_ready():
		await window.ready

	var filter_props: Array[Prop] = []
	for p in __properties__:
		if is_instance_valid(p.node) and p.name == _property:
			filter_props.append(p)

	var parent := _node.get_parent()
	while window != parent:
		for p in filter_props:
			if p.node == parent:
				return p.ref
		parent = parent.get_parent()

	return null


## Manually cleanup all properties for a specific node
static func cleanup_node(_node: Node) -> void:
	if not is_instance_valid(_node):
		return

	var to_remove: Array[Prop] = []
	for prop in __properties__:
		if prop.node == _node:
			to_remove.append(prop)

	for prop in to_remove:
		__properties__.erase(prop)
	pass


## Cleanup all invalid properties (nodes that have been freed)
static func cleanup_invalid() -> void:
	var to_remove: Array[Prop] = []
	for prop in __properties__:
		if not is_instance_valid(prop.node):
			to_remove.append(prop)

	for prop in to_remove:
		__properties__.erase(prop)
	pass
#endregion


#region provide and inject
class Prop:
	var node: Node
	var name: String
	var ref: Ref


	func _init(_node: Node, _name: String, _ref: Ref) -> void:
		node = _node
		name = _name
		ref = _ref

		_node.tree_exiting.connect(func(): Bindora._remove_prop(self))
		pass

	pass
