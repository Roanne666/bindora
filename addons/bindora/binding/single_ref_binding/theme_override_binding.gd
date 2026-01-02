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
var __property__: String

## The method name used to apply the override. (auto generate)
var __method__: String


func _init(_node: CanvasItem, _ref: RefVariant, _property: String) -> void:
	super(_node, _ref)

	for p in _node.get_property_list():
		if not p["name"].contains("/"):
			continue
		var split_p = p["name"].split("/")
		if split_p[1] == _property:
			__method__ = THEME_OVERRIDE_METHODS[split_p[0]]

	if not __method__:
		push_error("ThemeOverrideBinding: Node '%s' has invalid theme override property '%s'" % [_node.name, _property])
		return
		
	__property__ = _property
	_update(null, __ref__.value)
	pass


func _update(_old_value, _new_value) -> void:
	__node__.call(__method__, __property__, _new_value)
	pass
