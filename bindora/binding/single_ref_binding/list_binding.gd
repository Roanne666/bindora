class_name ListBinding extends SingleRefBinding
## List binding implementation similar to v-for functionality
##
## Dynamically manages a list of nodes based on an array reference.
## Automatically handles:
## - Adding new items when array grows
## - Removing items when array shrinks
## - Full refreshes when needed
## Uses a PackedScene template for each item in the list.

## The scene template to instantiate for each list item
var __packed_scene__: PackedScene

## The callback function to configure each new item
## Signature: func(instance: Node, data: Variant, index: int) -> void
var __callable__: Callable

var __bindings__: Array = []


func _init(_node: CanvasItem, _ref: RefArray, _packed_scene: PackedScene, _callable: Callable) -> void:
	super(_node, _ref)
	__packed_scene__ = _packed_scene
	__callable__ = _callable
	pass


func _update(_diff: int, _arg) -> void:
	if _diff > -1:
		# Handle incremental updates if we know the changed index
		if __ref__.size() > __node__.get_child_count():
			# Item was added - create and position new instance
			var data = __ref__.value[_diff]
			var instance = __packed_scene__.instantiate()
			__node__.add_child(instance)
			__node__.move_child(instance, _diff)
			__bindings__.insert(_diff, __callable__.call(instance, data, _diff))
		elif __ref__.size() < __node__.get_child_count():
			# Item was removed - clean up corresponding node
			var c = __node__.get_child(_diff)
			__node__.remove_child(c)
			c.queue_free()
	else:
		var index_mapping = _arg
		var current_children = __node__.get_children()

		var reordered_children = []
		reordered_children.resize(current_children.size())

		for old_index in index_mapping:
			var new_index = index_mapping[old_index]
			reordered_children[new_index] = current_children[old_index]

		var reordered_bindings = []
		reordered_bindings.resize(__bindings__.size())

		for old_index in index_mapping:
			var new_index = index_mapping[old_index]
			reordered_bindings[new_index] = __bindings__[old_index]

		for i in range(reordered_children.size()):
			if reordered_children[i]:
				__node__.move_child(reordered_children[i], i)
				reordered_bindings[i] = __callable__.call(reordered_children[i], __ref__.value[i], i)

		__bindings__ = reordered_bindings
	pass
