extends TextureRect
class_name GameLog

@export_category("Objetos")
@export var log_container: VBoxContainer
@export var max_messages: int
@export var font: Font


func add_message(msg: String, color: Color = Color.WHITE) -> void:
	var new_label = RichTextLabel.new()
	
	new_label.bbcode_enabled = true
	new_label.text = "[color=%s]%s[/color]" % [color.to_html(), msg]
	new_label.scroll_active = false
	new_label.scroll_following = false
	
	new_label.custom_minimum_size = Vector2(10, 11)
	new_label.add_theme_font_override("normal_font", font)
	new_label.add_theme_font_size_override("normal_font_size", 5)
	new_label.add_theme_constant_override("outline_size", 1)
	
	log_container.add_child(new_label)
