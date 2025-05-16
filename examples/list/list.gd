extends Control

@onready var item_list: VBoxContainer = $ItemList
@onready var add_item_button: Button = $AddItemButton
@onready var random_remove_button: Button = $RandomRemoveButton
@onready var random_modify_button: Button = $RandomModifyButton
@onready var reverse_items_button: Button = $ReverseItemsButton
@onready var sort_items_button: Button = $SortItemsButton
@onready var label: Label = $Label

const ITEM = preload("res://examples/list/item.tscn")
const NAMES := ["Tom", "Jerry", "Peter"]

var list_ref := RefArray.new()


func _ready() -> void:
	Person.uuid.bind_text(label)
	# RefList
	list_ref.bind_list(item_list, ITEM, _create_binding)
	for i in 3:
		_on_add_item_button_pressed()
	add_item_button.pressed.connect(_on_add_item_button_pressed)
	random_remove_button.pressed.connect(_on_random_remove_button_pressed)
	random_modify_button.pressed.connect(_random_modify_button_pressed)
	reverse_items_button.pressed.connect(list_ref.reverse)
	sort_items_button.pressed.connect(
		list_ref.sort_custom.bind(func(a: Person, b: Person): return a.uid.value < b.uid.value)
	)
	pass


func _on_add_item_button_pressed() -> void:
	list_ref.append(Person.new(NAMES.pick_random(), randi_range(20, 40)))
	pass


func _random_modify_button_pressed() -> void:
	var person = list_ref.value.pick_random() as Person
	person.full_name.value = NAMES.pick_random()
	person.age.value = randi_range(20, 40)
	pass


func _on_random_remove_button_pressed() -> void:
	if list_ref.value.size() > 0:
		list_ref.remove_at(randi_range(0, list_ref.value.size() - 1))
	pass


# Multi ref binding.
func _create_binding(_scene: Node, _data: Person, _index: int) -> void:
	TextBinding.new(_scene, {"uid": _data.uid, "full_name": _data.full_name, "age": _data.age})
	pass
