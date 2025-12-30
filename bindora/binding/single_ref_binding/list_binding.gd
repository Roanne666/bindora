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

## Node pool for reusing nodes
var __node_pool__: Array[Node] = []


func _init(_node: CanvasItem, _ref: RefArray, _packed_scene: PackedScene, _callable: Callable) -> void:
	super(_node, _ref)
	__packed_scene__ = _packed_scene
	__callable__ = _callable
	_update(-1, null)
	pass


func _dispose() -> void:
	for child in __node__.get_children():
		child.queue_free()
	__bindings__.clear()
	__node_pool__.clear()
	super._dispose()
	pass

func _get_or_create_node() -> Node:
	if __node_pool__.is_empty():
		return __packed_scene__.instantiate()
	return __node_pool__.pop_back()


func _recycle_node(node: Node) -> void:
	__node_pool__.push_back(node)
	pass

func _update(diff: int, arg) -> void:
	if diff > -1:
		_update_diff(diff)
	elif diff == -1:
		if arg == null:
			_update_array()
		else:
			_update_order(arg)
	pass


func _update_diff(diff) -> void:
	if __ref__.size() > __node__.get_child_count():
		var data = __ref__.value[diff]
		var instance = _get_or_create_node()
		__node__.add_child(instance)
		__node__.move_child(instance, diff)
		__bindings__.insert(diff, __callable__.call(instance, data, diff))
	elif __ref__.size() < __node__.get_child_count():
		var c = __node__.get_child(diff)
		__node__.remove_child(c)
		_recycle_node(c)
		__bindings__.pop_at(diff)
	else:
		for b in __bindings__[diff]:
			b._dispose()
		var node = __node__.get_child(diff)
		var new_data = __ref__.value[diff]
		__bindings__[diff] = __callable__.call(node, new_data, diff)
	pass

func _update_array() -> void:
	var current_children = __node__.get_children()
	var current_child_count = current_children.size()
	var new_size = __ref__.value.size()

	for bs in __bindings__:
		for b: Binding in bs:
			b._dispose()
	__bindings__.clear()

	if new_size > current_child_count:
		for i in range(current_child_count, new_size):
			var instance = _get_or_create_node()
			__node__.add_child(instance)
	elif new_size < current_child_count:
		for i in range(new_size, current_child_count):
			var child = __node__.get_child(new_size)
			__node__.remove_child(child)
			_recycle_node(child)

	current_children = __node__.get_children()
	for i in __ref__.value.size():
		__bindings__.append(__callable__.call(current_children[i], __ref__.value[i], i))
	pass

func _update_order(index_mapping: Dictionary) -> void:
	var current_children = __node__.get_children()
	var current_bindinds = __bindings__.map(func(b): return b)
	var reordered_children = []
	var reordered_bindings = []
	reordered_children.resize(current_children.size())
	reordered_bindings.resize(current_bindinds.size())

	for old_index in index_mapping:
		var new_index = index_mapping[old_index]
		reordered_children[new_index] = current_children[old_index]
		reordered_bindings[new_index] = current_bindinds[old_index]

	for i in reordered_children.size():
		__node__.move_child(reordered_children[i], i)
		__bindings__[i] = reordered_bindings[i]
	pass
