extends ColorRect
class_name Slot


func handler_slot_color(item_rarity: String) -> void:
	match item_rarity:
		"common":
			color = Color.WHITE
		
		"uncommon":
			color = Color.GREEN
		
		"rare":
			color = Color.BLUE
		
		"epic":
			color = Color.MAGENTA
		
		"legendary":
			color = Color.GOLD
