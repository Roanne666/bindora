@tool
class_name RefResource extends Ref

var resource_type: String


func _validate_property(property: Dictionary):
	if property["name"] == "value":
		property["hint"] = PROPERTY_HINT_RESOURCE_TYPE
		property["hint_string"] = resource_type
