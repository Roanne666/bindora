@tool
class_name RefDictionary extends Ref
## Dictionary reference class
##
## Note: Using dictionary reference class won't provide code completion or type checking.
## In principle, it's recommended to use [ReactiveResource] instead.


func set_value(_value: Dictionary) -> void:
	value = _value
	pass


func get_value() -> Dictionary:
	return value


func _init(_value:=Dictionary()) -> void:
	super(TYPE_DICTIONARY, _value)
	pass


## Quick method for [TextBinding], auto binds refs.
func bind_text(_node: CanvasItem, _template: String = "") -> TextBinding:
	var refs: Dictionary[String, Ref] = {}
	for p in get_property_list():
		var variable = self.get(p["name"])
		if variable is Ref:
			refs.set(p["name"], variable)
	return TextBinding.new(_node, refs, _template)
