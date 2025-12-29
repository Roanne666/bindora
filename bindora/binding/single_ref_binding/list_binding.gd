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
		# Clear existing children
		for c in __node__.get_children():
			__node__.remove_child(c)
			c.queue_free()

		# Create new children for all items
		for i in __ref__.value.size():
			var data = __ref__.value[i]
			var instance = __packed_scene__.instantiate()
			__node__.add_child(instance)
			__bindings__.insert(i, __callable__.call(instance, data, i))
	pass
