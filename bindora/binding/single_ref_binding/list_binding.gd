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
var packed_scene: PackedScene

## The callback function to configure each new item
## Signature: func(instance: Node, data: Variant, index: int) -> void
var callable: Callable

var __bindings__: Array = []


func _init(_node: CanvasItem, _ref: RefArray, _packed_scene: PackedScene, _callable: Callable) -> void:
	super (_node, _ref)
	packed_scene = _packed_scene
	callable = _callable
	pass


func _update(_diff: int, _arg) -> void:
	if _diff > -1:
		# Handle incremental updates if we know the changed index
		if ref.size() > node.get_child_count():
			# Item was added - create and position new instance
			var data = ref.value[_diff]
			var instance = packed_scene.instantiate()
			node.add_child(instance)
			node.move_child(instance, _diff)
			__bindings__.insert(_diff, callable.call(instance, data, _diff))
		elif ref.size() < node.get_child_count():
			for b in __bindings__[_diff]:
				if b is Binding:
					b.dispose()
			__bindings__.remove_at(_diff)

			# Item was removed - clean up corresponding node
			var c = node.get_child(_diff)
			node.remove_child(c)
			c.queue_free()
	else:
		# TODO: More efficient solution
		# Full refresh needed - rebuild entire list
		# Clear existing bindings
		for b in __bindings__:
			for bb in b:
				if bb is Binding:
					bb.dispose()
		__bindings__.clear()

		# Clear existing children
		for c in node.get_children():
			node.remove_child(c)
			c.queue_free()

		# Create new children for all items
		for i in ref.value.size():
			var data = ref.value[i]
			var instance = packed_scene.instantiate()
			node.add_child(instance)
			__bindings__.insert(i, callable.call(instance, data, i))
	pass
