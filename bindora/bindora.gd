class_name Bindora extends Object


#region provide and inject
class Prop:
	var node: Node
	var name: String
	var ref: Ref

	func _init(_node: Node, _name: String, _ref: Ref) -> void:
		node = _node
		name = _name
		ref = _ref
		pass

	pass

static var __properties__: Array[Prop] = []

static func provide(_node: Node, _property: String, _ref: Ref) -> void:
	for prop in __properties__:
		if prop.node == _node and prop.name == _property:
			return
	__properties__.append(Prop.new(_node, _property, _ref))
	pass

static func inject(_node: Node, _property: String) -> Ref:
	var window := _node.get_window()
	if not window.is_node_ready():
		await window.ready

	var filter_props: Array[Prop] = []
	for p in __properties__:
		if p.name == _property:
			filter_props.append(p)

	var parent := _node.get_parent()
	while window != parent:
		for p in filter_props:
			if p.node == parent:
				return p.ref
		parent = parent.get_parent()

	return null


#endregion
