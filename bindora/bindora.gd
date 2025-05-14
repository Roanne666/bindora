class_name Bindora extends RefCounted
## A utility class for serializing and deserializing [ReactiveResource].

const FLAGS = PROPERTY_USAGE_SCRIPT_VARIABLE


## Deserializes a [Dictionary] into a [ReactiveResource].
static func reactive(_dict: Dictionary, _class) -> ReactiveResource:
	var obj = _class.new()
	for prop in obj.get_property_list():
		if prop.usage & FLAGS > 0:
			var value = _dict.get(prop.name)
			var obj_value = obj.get(prop.name)
			if obj_value is Ref:
				obj_value.value = value
			else:
				obj.set(prop.name, value)
	return obj


## Serialize a [ReactiveResource] into a [Dictionary].
static func serialize(_obj: Resource) -> Dictionary:
	var dict := {}
	for prop in _obj.get_property_list():
		if prop.usage & FLAGS > 0:
			var value = _obj.get(prop.name)
			if value is Ref:
				value = value.value
			dict[prop.name] = value
	return dict
