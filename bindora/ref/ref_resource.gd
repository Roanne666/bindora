@tool
class_name RefResource extends Ref

var __resource_type__: String

func _init(_value, _resource_type: String) -> void:
	__type__ = TYPE_OBJECT
	__resource_type__ = _resource_type
	super (_value)
	pass

func _validate_property(property: Dictionary):
	if property["name"] == "value":
		property["hint"] = PROPERTY_HINT_RESOURCE_TYPE
		property["hint_string"] = __resource_type__
