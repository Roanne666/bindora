@tool
class_name RefResource extends Ref

var resource_type: String


func _get_property_list() -> Array[Dictionary]:
	return [
		{
			"name": "value",
			"type": type,
			"hint": PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string": resource_type,
			"usage": PROPERTY_USAGE_DEFAULT
		}
	]
