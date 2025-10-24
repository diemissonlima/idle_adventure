extends Node
class_name GlobalPlayer

# stats level player
var level: int = 1
var strength: int = 0
var agility: int = 0
var luck: int = 0
var magic_find: float = 0
var current_exp: float = 0.0
var available_stats_points: int = 0
var avg_power_level: int = 0

# status de dano
var dps_damage: float = 0.0
var click_damage: float = 1.0
var gold_resource: float = 0#16330000000000000000000.0
var scrap_resource: float = 0.0

# itens equipados
var equipped_items := {
	"helmet": null,
	"armor": null,
	"necklace": null,
	"weapon": null,
	"shield": null,
	"belt": null,
	"legs": null,
	"ring_1": null,
	"ring_2": null
}

# bonus de upgrade permanente
var permanent_bonus: Dictionary = {
	"gold_mastery": {
		"name": "Gold Mastery",
		"level": 0,
		"cost": 250,
		"bonus": 0.0
	},
	
	"scrap_scavenger": {
		"name": "Scrap Scavenger",
		"level": 0,
		"cost": 500,
		"bonus": 0.0
	},
	
	"critical_power": {
		"name": "Critical Power",
		"level": 0,
		"cost": 3500,
		"bonus": 0.0
	},
	
	"critical_damage": {
		"name": "Critical Damage",
		"level": 0,
		"cost": 800,
		"bonus": 0.0
	},
	
	"boss_hunter": {
		"name": "Boss Hunter",
		"level": 0,
		"cost": 10000,
		"bonus": 0.0
	},
	
	"swift_strikes": {
		"name": "Swift Strikes",
		"level": 0,
		"cost": 50000,
		"bonus": 0.0
	},
	
	"hunters_acumen": {
		"name": "Hunter's Acumen",
		"level": 0,
		"cost": 1000000,
		"bonus": 0
	},
	
	"prestige_surge": {
		"name": "Prestige Surge",
		"level": 0,
		"cost": 25000,
		"bonus": {
			"click": 0.0,
			"dps": 0.0
		}
	},
	
	"legacy_keeper": {
		"name": "Legacy Keeper",
		"level": 0,
		"cost": 1000000,
		"bonus": 0
	},
}

# dicionario com exp necessaria pra passar de level
var level_dict: Dictionary


func cause_damage(type_damage: String) -> void:
	var rng: float = randf()
	var critical_chance: float = permanent_bonus["critical_power"]["bonus"]
	var multiplier_damage: float = permanent_bonus["critical_damage"]["bonus"]
	var base_critical: float = 1.5
	var base_damage: float = 0.0
	var bonus_damage: float = 0.0
	var final_damage: float = 0.0
	
	match type_damage:
		"dps_damage":
			base_damage = dps_damage
			if critical_chance >= rng:
				base_damage *= base_critical # dano base * 1.5 (critico_base)
				bonus_damage = base_damage * multiplier_damage
				final_damage = base_damage + bonus_damage
				
				get_tree().call_group("enemy", "take_damage", final_damage)
			else:
				get_tree().call_group("enemy", "take_damage", dps_damage)
			
		"click_damage":
			base_damage = click_damage
			if critical_chance >= rng:
				base_damage *= base_critical
				bonus_damage = base_damage * multiplier_damage
				final_damage = base_damage + bonus_damage
				
				get_tree().call_group("enemy", "take_damage", final_damage)
			else:
				get_tree().call_group("enemy", "take_damage", click_damage)


func improve_gold(value: float) -> void:
	var bonus_from_gold_mastery: float = permanent_bonus["gold_mastery"]["bonus"]
	var bonus_from_luck: float = luck * 2
	var total_bonus: float = (luck * 0.2) + bonus_from_gold_mastery + bonus_from_luck
	
	var gold_dropped: float = value + (value * (total_bonus / 100))
	
	#print("gold base: ", value)
	#print("bonus gold mastery: ", bonus_from_gold_mastery)
	#print("bonus luck: ", bonus_from_luck)
	#print("bonus 2 luck: ", float(luck * 0.2))
	#print("total bonus: ", total_bonus)
	#print("gold dropado: ", gold_dropped)
	#print("-=-=-=-=-=-=-=-=-=-=-=")
	
	gold_resource += gold_dropped
	
	get_tree().call_group("main_scene", "update_label")
	get_tree().call_group(
		"game_log", "add_message",
		"You gained " + str(World.format_number(gold_dropped)) + " gold."
		)


func improve_damage(type: String, improve_type: String) -> void:
	match type:
		"dps":
			# +10 flat +1% total dps por level
			if improve_type == "gold_upgrade":
				World.dps_damage_level += 1
				gold_resource -= World.dps_damage_cost
				World.dps_damage_cost += World.dps_damage_cost * 0.19
				get_tree().call_group(
					"game_log", "add_message", 
					"DPS Damage increased to level " + str(World.dps_damage_level)
				)
			
			var bonus_percent_dps: float = (World.dps_damage_level * 1) + (agility * 0.8)
			var bonus_flat_dps: float = (World.dps_damage_level * 10) + (agility * 10)
			var dps_base_damage: float = bonus_flat_dps
			var dps_bonus_damage: float = dps_base_damage * (bonus_percent_dps / 100)
			
			dps_damage = dps_base_damage + dps_bonus_damage
			
			#print("% DPS Bonus: ", bonus_percent_dps)
			#print("Flat bonus: ",bonus_flat_dps )
			#print("DPS base damage: ", dps_base_damage)
			#print("DPS bonus damage: ", dps_bonus_damage)
			#print("DPS final damage: ", dps_damage)
			#print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
			
		"click":
			# +5 flat +1% total dps por level
			if improve_type == "gold_upgrade":
				World.click_damage_level += 1
				gold_resource -= World.click_damage_cost
				World.click_damage_cost += World.click_damage_cost * 0.30
				get_tree().call_group(
					"game_log", "add_message", 
					"Click Damage increased to level " + str(World.click_damage_level)
					)
			
			var bonus_percent_click: float = (World.click_damage_level * 1) + (strength * 0.2)
			var bonus_flat_click: float = (World.click_damage_level * 5) + (strength * 5)
			var click_base_damage: float = bonus_flat_click
			var click_bonus_damage: float = click_base_damage * (bonus_percent_click / 100)
			
			click_damage = click_base_damage + click_bonus_damage


func improve_upgrades(upgrade_name: String) -> void:
	if gold_resource < permanent_bonus[upgrade_name]["cost"]:
		return
		
	gold_resource -= permanent_bonus[upgrade_name]["cost"]
	permanent_bonus[upgrade_name]["level"] += 1
	
	match upgrade_name:
		"gold_mastery":
			permanent_bonus["gold_mastery"]["cost"] += permanent_bonus["gold_mastery"]["cost"] * 0.22
			permanent_bonus["gold_mastery"]["bonus"] += 0.01
		
		"scrap_scavenger":
			permanent_bonus["scrap_scavenger"]["cost"] += permanent_bonus["scrap_scavenger"]["cost"] * 0.45
			permanent_bonus["scrap_scavenger"]["bonus"] += 0.02
		
		"critical_power":
			permanent_bonus["critical_power"]["cost"] += permanent_bonus["critical_power"]["cost"] * 0.80
			permanent_bonus["critical_power"]["bonus"] += 0.01
		
		"critical_damage":
			permanent_bonus["critical_damage"]["cost"] += permanent_bonus["critical_damage"]["cost"] * 0.35
			permanent_bonus["critical_damage"]["bonus"] += 0.05
		
		"boss_hunter":
			permanent_bonus["boss_hunter"]["cost"] += permanent_bonus["boss_hunter"]["cost"] * 0.55
			permanent_bonus["boss_hunter"]["bonus"] += 0.02
		
		"swift_strikes":
			permanent_bonus["swift_strikes"]["cost"] += permanent_bonus["swift_strikes"]["cost"] * 1.5
			permanent_bonus["swift_strikes"]["bonus"] += 0.005
		
		"hunters_acumen":
			permanent_bonus["hunters_acumen"]["cost"] += permanent_bonus["hunters_acumen"]["cost"] * 14
			permanent_bonus["hunters_acumen"]["bonus"] += 1
		
		"prestige_surge":
			permanent_bonus["prestige_surge"]["cost"] += permanent_bonus["prestige_surge"]["cost"] * 2
			permanent_bonus["prestige_surge"]["bonus"]["click"] += 1000
			permanent_bonus["prestige_surge"]["bonus"]["dps"] += 5000
		
		"legacy_keeper":
			permanent_bonus["legacy_keeper"]["cost"] += permanent_bonus["legacy_keeper"]["cost"] * 100
			permanent_bonus["legacy_keeper"]["bonus"] += 1
		
	
	var log_msg: String = (
		"Purchase Level " + str(permanent_bonus[upgrade_name]["level"]) + 
		" of " + permanent_bonus[upgrade_name]["name"]
		)
	
	get_tree().call_group("game_log", "add_message", log_msg)
	get_tree().call_group("main_scene", "update_label")


func update_exp(value: float) -> void:
	current_exp += value
	var log_msg: String = "You gained " + World.format_number(value) + " XP."
	
	if current_exp >= level_dict[str(level)]:
		var leftover = current_exp - level_dict[str(level)]
		current_exp = leftover
		on_level_up()
	
	get_tree().call_group("game_log", "add_message", log_msg)
	get_tree().call_group("stats_container", "update_exp_bar")


func on_level_up() -> void:
	level += 1
	available_stats_points += 2
	
	var log_msg: String = "Congratulations, you reached lvl " + str(level) + "."
	get_tree().call_group("game_log", "add_message", log_msg)
	get_tree().call_group("stats_container", "update_label")
