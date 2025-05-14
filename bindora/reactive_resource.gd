@tool
class_name ReactiveResource extends Resource
## A resource that can be serialized and deserialized.

var __refs__: Dictionary[String, Variant.Type] = {}

func _init() -> void:
	__refs__ = {}
	for p in get_property_list():
		var ref = get(p["name"])
		if ref is Ref:
			__refs__.set(p["name"], ref.type)

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	for k in __refs__:
		properties.append({"name": "_%s" %k, "type": __refs__[k], "usage": PROPERTY_USAGE_DEFAULT})
	return properties

func _set(property: StringName, value: Variant) -> bool:
	var ref_name = property.get_slice("_", 1)
	if ref_name in __refs__:
		var ref = get(ref_name)
		if ref is Ref:
			ref.value = value
			return true
	return false

func _get(property: StringName) -> Variant:
	var ref_name = property.get_slice("_", 1)
	if ref_name in __refs__:
		var ref = get(ref_name)
		if ref is Ref:
			return ref.value
	return null

## Serialize self into a dictionary.
func to_dictionary() -> Dictionary:
	var dict := {}
	for prop in get_property_list():
		if prop["name"] == "__refs__":
			continue
		if prop["usage"] & Bindora.FLAGS > 0:
			var value = get(prop.name)
			if value is Ref:
				value = value.value
			dict[prop.name] = value
	return dict

## Update self from a dictionary.
func from_dictionary(_dict: Dictionary) -> void:
	for prop in get_property_list():
		if prop["usage"] & Bindora.FLAGS > 0:
			var variable = get(prop["name"])
			if variable is Ref:
				variable.value = _dict.get(prop["name"])
	pass
