extends Control

@onready var item_list: VBoxContainer = $ItemList
@onready var add_item_button: Button = $AddItemButton
@onready var random_remove_button: Button = $RandomRemoveButton
@onready var random_modify_button: Button = $RandomModifyButton
@onready var reverse_items_button: Button = $ReverseItemsButton
@onready var sort_items_button: Button = $SortItemsButton
@onready var add_multi_items_button: Button = $AddMultiItemsButton
@onready var set_new_array_button: Button = $SetNewArrayButton
@onready var label: Label = $Label


const ITEM = preload("res://examples/list/item.tscn")
const NAMES := ["Tom", "Jerry", "Peter"]

var list_ref := RefArray.new()


func _ready() -> void:
	Person.uuid.bind_text(label)
	# RefList
	for i in 3:
		_on_add_item_button_pressed()
	list_ref.bind_list(item_list, ITEM, _create_binding)

	add_item_button.pressed.connect(_measure_performance.bind("add_single", func(): _on_add_item_button_pressed()))
	random_remove_button.pressed.connect(_measure_performance.bind("remove", func(): _on_random_remove_button_pressed()))
	random_modify_button.pressed.connect(_measure_performance.bind("modify", func(): _random_modify_button_pressed()))
	reverse_items_button.pressed.connect(_measure_performance.bind("reverse", func(): list_ref.reverse()))
	sort_items_button.pressed.connect(_measure_performance.bind("sort", func(): list_ref.sort_custom(func(a: Person, b: Person): return a.uid.value < b.uid.value)))
	add_multi_items_button.pressed.connect(_measure_performance.bind("add_1000", func(): _on_add_multi_items_button_pressed()))
	set_new_array_button.pressed.connect(_measure_performance.bind("set_new_array",func():_on_set_new_array_button_pressed()))
	pass


func _measure_performance(operation_name: String, operation: Callable) -> void:
	var start_time = Time.get_ticks_msec()
	var start_count = list_ref.value.size()

	# Execute the operation
	if operation.is_valid():
		operation.call()

	var end_time = Time.get_ticks_msec()
	var end_count = list_ref.value.size()
	var duration = end_time - start_time

	# Print performance data
	print("=== PERFORMANCE: %s ===" % operation_name)
	print("Duration: %d ms" % duration)
	print("Items before: %d" % start_count)
	print("Items after: %d" % end_count)
	print("Time per item: %.2f ms" % (float(duration) / max(1, abs(end_count - start_count)) if end_count != start_count else float(duration) / max(1, start_count)))
	print("")


func _on_add_item_button_pressed() -> void:
	list_ref.append(Person.new(NAMES.pick_random(), randi_range(20, 40)))


func _random_modify_button_pressed() -> void:
	if list_ref.value.size() > 0:
		var person = list_ref.value.pick_random() as Person
		person.full_name.value = NAMES.pick_random()
		person.age.value = randi_range(20, 40)


func _on_random_remove_button_pressed() -> void:
	if list_ref.value.size() > 0:
		list_ref.remove_at(randi_range(0, list_ref.value.size() - 1))


func _on_add_multi_items_button_pressed() -> void:
	for i in 1000:
		list_ref.append(Person.new(NAMES.pick_random(), randi_range(20, 40)))

func _on_set_new_array_button_pressed()->void:
	var new_value :Array[Person]= []
	for i in 1000:
		new_value.append(Person.new(NAMES.pick_random(), randi_range(20, 40)))
	list_ref.set_value(new_value)

# Multi ref binding.
func _create_binding(_scene: Node, _data: Person, _index: int) -> Array[Binding]:
	return [TextBinding.new(_scene, {"uid": _data.uid, "full_name": _data.full_name, "age": _data.age})]
