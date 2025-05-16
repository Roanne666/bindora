class_name Person extends RefCounted

static var uuid := RefInt.new()

var uid: RefInt
var full_name: RefString
var age: RefInt


func _init(_full_name: String, _age: int) -> void:
	uid = RefInt.new(uuid.value)
	full_name = RefString.new(_full_name)
	age = RefInt.new(_age)
	uuid.value += 1
