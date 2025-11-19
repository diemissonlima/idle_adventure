extends TextureRect
class_name GameLog

@export_category("Objetos")
@export var log_container: VBoxContainer
@export var scroll_container: ScrollContainer
@export var max_messages: int
@export var font: Font

var automatic_scroll: bool = true


func add_message(msg: String, color: Color = Color.WHITE) -> void:
	var new_label = RichTextLabel.new()
	
	new_label.bbcode_enabled = true
	new_label.text = "[color=%s]%s[/color]" % [color.to_html(), msg]
	new_label.scroll_active = false
	new_label.scroll_following = false
	new_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	new_label.custom_minimum_size = Vector2(10, 11)
	new_label.add_theme_font_override("normal_font", font)
	new_label.add_theme_font_size_override("normal_font_size", 5)
	new_label.add_theme_constant_override("outline_size", 1)
	
	log_container.add_child(new_label)
	
	if log_container.get_child_count() > max_messages:
		log_container.get_child(0).queue_free()
	
	if automatic_scroll:
		await get_tree().process_frame
		scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value


func _on_log_container_mouse_entered() -> void:
	automatic_scroll = false


func _on_log_container_mouse_exited() -> void:
	automatic_scroll = true


func _on_btn_view_log_pressed() -> void:
	$BtnViewLoot.visible = true
	$BtnViewLog.visible = false
	
	$LogContainer.visible = true
	$LootContainer.visible = false

func _on_btn_view_loot_pressed() -> void:
	$BtnViewLoot.visible = false
	$BtnViewLog.visible = true
	
	$LogContainer.visible = false
	$LootContainer.visible = true
