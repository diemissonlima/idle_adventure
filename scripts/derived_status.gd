extends TextureRect
class_name DerivedStats

@export_category("Objetos")
@export var icon_click: TextureRect
@export var icon_gold: TextureRect
@export var icon_magig_find: TextureRect
@export var icon_dps: TextureRect


func _ready() -> void:
	update_label("IconClick")
	update_label("IconGold")
	update_label("IconMagicFind")
	update_label("IconDPS")
	connect_signal()
	

func connect_signal() -> void:
	for icon in self.get_children():
		if icon is TextureRect:
			icon.mouse_entered.connect(on_mouse_entered.bind(icon))
			icon.mouse_exited.connect(on_mouse_exited.bind(icon))


func on_mouse_entered(icon: TextureRect) -> void:
	icon.get_node("Info").visible = true
	update_label(icon.name)


func on_mouse_exited(icon: TextureRect) -> void:
	icon.get_node("Info").visible = false


func update_label(icon_name: String) -> void:
	var total: float = 0.0
	
	match icon_name:
		"IconClick":
			total = Player.click_damage
			
			icon_click.get_node("Info/VBoxContainer/StrengthFlat").text = (
				"From Strength: + " + str(Player.strength * 5)
			)
			icon_click.get_node("Info/VBoxContainer/StrengthPercent").text = (
				"From Strength: + " + str(Player.strength * 0.2) + "%"
			)
			icon_click.get_node("Info/VBoxContainer/GoldUpgradeFlat").text = (
				"From Gold Upgrade: + " + str(World.click_damage_level * 5)
			)
			icon_click.get_node("Info/VBoxContainer/GoldUpgradePercent").text = (
				"From Gold Upgrade: + " + str(World.click_damage_level * 1) + "%"
			)
			icon_click.get_node("Label").text = str(total)
		
		"IconGold":
			total = ((Player.luck * 2) + (Player.luck * 0.2)) + Player.permanent_bonus["gold_mastery"]["bonus"] * 100
			
			icon_gold.get_node("Info/VBoxContainer/LuckFlat").text = (
				"From Luck: + " + str(Player.luck * 2) + " %"
			)
			icon_gold.get_node("Info/VBoxContainer/LuckPercent").text = (
				"From Luck: + " + str(Player.luck * 0.2) + " %"
			)
			icon_gold.get_node("Info/VBoxContainer/GoldUpgrade").text = (
				"From Upgrades: + " 
				+ str(Player.permanent_bonus["gold_mastery"]["bonus"] * 100) + " %"
			)
			icon_gold.get_node("Label").text = World.format_number(total) + " %"
			
		"IconMagicFind":
			total = Player.luck * 0.1
			
			icon_magig_find.get_node("Info/VBoxContainer/LuckFlat").text = (
				"From Luck: + " + str(Player.luck * 0.1) + " %"
			)
			icon_magig_find.get_node("Label").text = str(total) + " %"
		
		"IconDPS":
			total = Player.dps_damage
			
			icon_dps.get_node("Info/VBoxContainer/AgilityFlat").text = (
				"From Agility: + " + str(Player.agility * 10)
			)
			icon_dps.get_node("Info/VBoxContainer/AgilityPercent").text = (
				"From Agility: + " + str(Player.agility * 0.8) + " %"
			)
			icon_dps.get_node("Info/VBoxContainer/GoldUpgradeFlat").text = (
				"From Gold Upgrade: + " + str(World.dps_damage_level * 10)
			)
			icon_dps.get_node("Info/VBoxContainer/GoldUpgradePercent").text = (
				"From Gold Upgrade: + " + str(World.dps_damage_level * 1) + " %"
			)
			icon_dps.get_node("Label").text = str(total)
