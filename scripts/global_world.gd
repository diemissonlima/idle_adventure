extends Node
class_name GlobalWorld


var level: int = 1

var dps_damage_cost: int = 25
var dps_damage_level: int = 0
var click_damage_cost: int = 10
var click_damage_level: int = 0

var gold_range: Dictionary


func _ready() -> void:
	var file_path = "res://scripts/gold_range.json"
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json = JSON.new()
		var result = json.parse(json_text)
		
		if result == OK:
			gold_range = json.get_data()
			print("JSON carregado com sucesso")
		else:
			push_error("erro ao parsear JSON: ", str(result))
	else:
		push_error("erro ao abrir arquivo JSON em: " + file_path)


func format_number(value: float) -> String:
	var suffixes = [
		"", "K", "M", "B", "T", "a", "b", "c", "d", "e", "f", "g", "h", 
		"i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", 
		"x", "y", "z", "aa", "ab", "ac", "ad", "ae", "af", "ag", "ah", "ai", "aj", 
		"ak", "al", "am", "an", "ao", "ap", "aq", "ar", "as", "at", "au", "av", 
		"aw", "ax", "ay", "az", "ba", "bb", "bc", "bd", "be", "bf", "bg", "bh",
		"bi", "bj", "bk", "bl", "bm", "bn", "bo", "bp", "bq", "br", "bs", "bt",
		"bu", "bv", "bw", "bx", "by", "bz"
	]

	var index = 0
	while value >= 1000.0 and index < suffixes.size() - 1:
		value /= 1000.0
		index += 1
	
	return String.num(value, 2) + suffixes[index]


func get_gold_range(level: String) -> Array:
	return gold_range[level]
