class_name ThemeOverrideBinding extends SingleRefBinding
## Theme override binding that dynamically updates theme properties
##
## Automatically manages theme overrides for various node properties including:
## - Colors
## - Fonts
## - Icons
## - Styleboxes
## - Font sizes
## - Constants

## Maps theme override categories to their corresponding methods
const THEME_OVERRIDE_METHODS = {
	"theme_override_colors": "add_theme_color_override",
	"theme_override_constants": "add_theme_constant_override",
	"theme_override_fonts": "add_theme_font_override",
	"theme_override_font_sizes": "add_theme_font_size_override",
	"theme_override_icons": "add_theme_icon_override",
	"theme_override_styles": "add_theme_stylebox_override"
}

## The specific theme property being overridden. (e.g. "font_color")
var property: String

## The method name used to apply the override. (auto generate)
var method: String


func _init(_node: CanvasItem, _ref: RefVariant, _property: String) -> void:
	super (_node, _ref)
	for p in _node.get_property_list():
		if not p["name"].contains("/"):
			continue
		var split_p = p["name"].split("/")
		if split_p[1] == _property:
			method = THEME_OVERRIDE_METHODS[split_p[0]]
	if not method:
		push_error("%s is not a valid theme override property" % _property)
		return
	property = _property
	update(ref.value)
	pass


func update(_new_value: Variant) -> void:
	node.call(method, property, _new_value)
	pass
