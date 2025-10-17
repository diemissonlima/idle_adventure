extends Node
class_name GlobalPlayer

# status de dano
var dps_damage: float = 0.0
var click_damage: float = 1.0
var gold_resource: float = 0.0
var scrap_resource: float = 0.0

# bonus de upgrade permanente
var permanent_bonus: Dictionary = {
	"gold_mastery": {
		"level": 0,
		"cost": 250,
		"bonus": 0.0
	}
}


func improve_gold() -> void:
	var gold_range = World.get_gold_range(str(World.level))
	var gold_dropped: float = randi_range(gold_range[0], gold_range[1])
	var msg_log = "You gained " + str(World.format_number(gold_dropped)) + " gold."
	
	var bonus_gold = gold_dropped * permanent_bonus["gold_mastery"]["bonus"]
	print("Gold dropado: ", gold_dropped)
	print("% de drop bonus: ", permanent_bonus["gold_mastery"]["bonus"] * 100, "%")
	print("Gold bonus: ", bonus_gold)
	print("Total gold dropado: ", round(gold_dropped + bonus_gold))
	print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
	
	gold_resource += gold_dropped
	
	get_tree().call_group("main_scene", "update_label")
	get_tree().call_group("game_log", "add_message", msg_log)


func improve_damage(type: String) -> void:
	var bonus_percent: float = World.dps_damage_level
	var bonus_flat: float
	var log_msg: String
	
	match type:
		"dps":
			# +10 flat +1% total dps por level
			bonus_flat = 10
			var bonus_damage: float = (dps_damage * (bonus_percent / 100)) + bonus_flat
			
			World.dps_damage_level += 1 # aumenta o level do dps damage
			dps_damage += round(bonus_damage) # aumenta o poder do dps damage
			gold_resource -= World.dps_damage_cost # deduz o custo do upgrade
			World.dps_damage_cost += World.dps_damage_cost * 0.35 # calcula o novo custo do upgrade
		
			log_msg = "DPS Damage increased to level " + str(World.dps_damage_level)
		
		"click":
			# +5 flat +1% total dps por level
			bonus_flat = 5
			var bonus_damage: float = (click_damage * (bonus_percent / 100)) + bonus_flat
			
			World.click_damage_level += 1
			click_damage += round(bonus_damage)
			gold_resource -= World.click_damage_cost
			World.click_damage_cost += World.click_damage_cost * 0.40
		
			log_msg = "Click Damage increased to level " + str(World.click_damage_level)
			
	get_tree().call_group("game_log", "add_message", log_msg)


func improve_upgrades(upgrade_name: String) -> void:
	match upgrade_name:
		"gold_mastery":
			if gold_resource >= permanent_bonus["gold_mastery"]["cost"]:
				gold_resource -= permanent_bonus["gold_mastery"]["cost"]
				permanent_bonus["gold_mastery"]["cost"] += permanent_bonus["gold_mastery"]["cost"] * 0.35
				permanent_bonus["gold_mastery"]["level"] += 1
				permanent_bonus["gold_mastery"]["bonus"] += 0.01
		
	get_tree().call_group("main_scene", "update_label")
