extends Node
class_name GlobalPlayer

# status de dano
var dps_damage: float = 0.0
var click_damage: float = 1.0
var gold_resource: float = 100000000000000000
var scrap_resource: float = 0.0

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


func improve_gold() -> void:
	var gold_range = World.get_gold_range(str(World.level))
	var gold_dropped: float = randi_range(gold_range[0], gold_range[1])
	var bonus_gold = gold_dropped * permanent_bonus["gold_mastery"]["bonus"]
	var final_gold: float = gold_dropped + bonus_gold
	var msg_log = "You gained " + str(World.format_number(final_gold)) + " gold."
	
	gold_resource += final_gold
	
	get_tree().call_group("main_scene", "update_label")
	get_tree().call_group("game_log", "add_message", msg_log)


func improve_damage(type: String) -> void:
	var bonus_percent: float = World.dps_damage_level
	var bonus_flat: float
	var log_msg: String
	
	match type:
		"dps":
			# +5 flat +1% total dps por level
			World.dps_damage_level += 1
			var base_damage: float = World.dps_damage_level * 5
			var bonus_damage: float = base_damage * (bonus_percent / 100)
			var total_dps: float = base_damage + bonus_damage
			
			dps_damage += total_dps
			
			gold_resource -= World.dps_damage_cost
			World.dps_damage_cost += World.dps_damage_cost * 0.19
			
			log_msg = "DPS Damage increased to level " + str(World.dps_damage_level)
		
		"click":
			# +2.5 flat +1% total dps por level
			World.click_damage_level += 1
			var base_damage: float = World.click_damage_level * 2.5
			var bonus_damage: float = base_damage * (bonus_percent / 100)
			var total_click_damage: float = base_damage + bonus_damage
			
			click_damage += total_click_damage
			
			gold_resource -= World.click_damage_cost
			World.click_damage_cost += World.click_damage_cost * 0.30
		
			log_msg = "Click Damage increased to level " + str(World.click_damage_level)
			
	get_tree().call_group("game_log", "add_message", log_msg)


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
