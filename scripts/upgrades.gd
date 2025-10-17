extends TextureRect
class_name Upgrades

@export_category("Gold Mastery")
@export var gold_level_label: Label
@export var gold_cost_label: Label
@export var gold_mastery_description: Label

@export_category("Scrap Scavenger")
@export var scrap_level_label: Label
@export var scrap_cost_label: Label
@export var scrap_scavenger_description: Label

@export_category("Critical Power")
@export var critical_power_level_label: Label
@export var critical_power_cost_label: Label
@export var critical_power_description: Label

@export_category("Critical Damage")
@export var critical_damage_level_label: Label
@export var critical_damage_cost_label: Label
@export var critical_damage_description: Label

@export_category("Boss Hunter")
@export var boss_hunter_level_label: Label
@export var boss_hunter_cost_label: Label
@export var boss_hunter_description: Label

@export_category("Swift Strikes")
@export var swift_strikes_level_label: Label
@export var swift_strikes_cost_label: Label
@export var swift_strikes_description: Label

@export_category("Hunters Acumen")
@export var hunters_acumen_level_label: Label
@export var hunters_acumen_cost_label: Label
@export var hunters_acumen_description: Label

@export_category("Prestige Surge")
@export var prestige_surge_level_label: Label
@export var prestige_surge_cost_label: Label
@export var prestige_surge_description: Label

@export_category("Legacy Keeper")
@export var legacy_keeper_level_label: Label
@export var legacy_keeper_cost_label: Label
@export var legacy_keeper_description: Label


func _ready() -> void:
	for upgrade_name in Player.permanent_bonus.keys():
		update_label(upgrade_name)


func _on_btn_buy_gold_mastery_pressed() -> void:
	Player.improve_upgrades("gold_mastery")
	update_label("gold_mastery")


func _on_btn_buy_scrap_scavenger_pressed() -> void:
	Player.improve_upgrades("scrap_scavenger")
	update_label("scrap_scavenger")


func _on_btn_buy_critical_power_pressed() -> void:
	Player.improve_upgrades("critical_power")
	update_label("critical_power")


func _on_btn_buy_critical_damage_pressed() -> void:
	Player.improve_upgrades("critical_damage")
	update_label("critical_damage")


func _on_btn_buy_boss_hunter_pressed() -> void:
	Player.improve_upgrades("boss_hunter")
	update_label("boss_hunter")


func _on_btn_buy_swift_strikes_pressed() -> void:
	Player.improve_upgrades("swift_strikes")
	update_label("swift_strikes")


func _on_btn_buy_hunters_acumen_pressed() -> void:
	Player.improve_upgrades("hunters_acumen")
	update_label("hunters_acumen")


func _on_btn_buy_prestige_surge_pressed() -> void:
	Player.improve_upgrades("prestige_surge")
	update_label("prestige_surge")


func _on_btn_buy_legacy_keeper_pressed() -> void:
	Player.improve_upgrades("legacy_keeper")
	update_label("legacy_keeper")


func update_label(upgrade_name: String) -> void:
	match upgrade_name:
		"gold_mastery":
			gold_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["gold_mastery"]["level"]) + " / ∞"
			gold_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["gold_mastery"]["cost"])) + " Gold"
			gold_mastery_description.text = (
				"Increases the base\nGold dropped by monsters\nby " + 
				str(Player.permanent_bonus["gold_mastery"]["bonus"] * 100) + "%."
			)
			
		"scrap_scavenger":
			scrap_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["scrap_scavenger"]["level"]) + " / ∞"
			scrap_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["scrap_scavenger"]["cost"])) + " Gold"
			scrap_scavenger_description.text = (
				"Gain " + str(Player.permanent_bonus["scrap_scavenger"]["bonus"] * 100) + 
				"% more Scrap\nfrom salvaging items."
			)
		
		"critical_power":
			critical_power_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["critical_power"]["level"]) + " / 100"
			critical_power_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["critical_power"]["cost"])) + " Gold"
			critical_power_description.text = (
				"Gain a " + str(Player.permanent_bonus["critical_power"]["bonus"] * 100) + 
				"% chance to\ndeal a critical hit."
			)
		
		"critical_damage":
			critical_damage_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["critical_damage"]["level"]) + " / ∞"
			critical_damage_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["critical_damage"]["cost"])) + " Gold"
			critical_damage_description.text = (
				"Critical hits deal an\nadditional " + 
				str(Player.permanent_bonus["critical_damage"]["bonus"] * 100) + "% damage.
				Base crit damage is 1.5x."
			)
		
		"boss_hunter":
			boss_hunter_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["boss_hunter"]["level"]) + " / ∞"
			boss_hunter_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["boss_hunter"]["cost"])) + " Gold"
			boss_hunter_description.text = (
				"Deal " + str(Player.permanent_bonus["boss_hunter"]["bonus"] * 100) + "% more damage to
				Mini-Bosses, Bosses, 
				and Big-Bosses"
			)
		
		"swift_strikes":
			swift_strikes_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["swift_strikes"]["level"]) + " / 200"
			swift_strikes_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["swift_strikes"]["cost"])) + " Gold"
			swift_strikes_description.text = (
				"Your attacks have a " + str(Player.permanent_bonus["swift_strikes"]["bonus"] * 100) + " %
				chance to hit an additional
				time."
			)
		
		"hunters_acumen":
			hunters_acumen_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["hunters_acumen"]["level"]) + " / ∞"
			hunters_acumen_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["hunters_acumen"]["cost"])) + " Gold"
			hunters_acumen_description.text = (
				"Gain " + str(Player.permanent_bonus["hunters_acumen"]["bonus"]) + " additional Hunt 
				Token(s) from completing\nbounties."
			)
			
		"prestige_surge":
			prestige_surge_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["prestige_surge"]["level"]) + " / ∞"
			prestige_surge_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["prestige_surge"]["cost"])) + " Gold"
			prestige_surge_description.text = (
				"Gain a flat " + World.format_number(Player.permanent_bonus["prestige_surge"]["bonus"]["click"]) + " Click
				Damage and " + World.format_number(Player.permanent_bonus["prestige_surge"]["bonus"]["dps"]) + " 
				DPS bonus for each\ntime your have prestiged."
			)
			
		"legacy_keeper":
			legacy_keeper_level_label.text = "Level:\n" + str(
				Player.permanent_bonus["legacy_keeper"]["level"]) + " / 8"
			legacy_keeper_cost_label.text = "Cost " + str(
				World.format_number(Player.permanent_bonus["legacy_keeper"]["cost"])) + " Gold"
			legacy_keeper_description.text = (
				"Unlock " + str(Player.permanent_bonus["legacy_keeper"]["bonus"]) + " additional Legacy
				Slot(s) to absorb items\nduring Prestige."
			)
