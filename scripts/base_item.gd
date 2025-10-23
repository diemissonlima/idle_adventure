extends StaticBody2D
class_name BaseItem

@export var item_name: String
@export var item_sprite: TextureRect
@export_enum(
	"Common", "Uncommon", "Rare", "Epic", "Legendary"
	) var item_rarity: String = "Commom"
@export_enum(
	"helmet", "armor", "necklace", "weapon", "shield", "belt", "legs", "ring"
	) var item_type
@export var item_unique: bool = false
@export var power_level: int = 0

@export var gold_gain: float = 0.0
@export var dps_damage: float = 0.0
@export var click_damage: float = 0.0
@export var magic_find: float = 0.0


func get_total_power() -> float:
	var rarity_mult = {
		"Common": 1.0,
		"Uncommon": 1.1,
		"Rare": 1.25,
		"Epic": 1.5,
		"Legendary": 2.0
	}
	
	return power_level * rarity_mult[item_rarity]
