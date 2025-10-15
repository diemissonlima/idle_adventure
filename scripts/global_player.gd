extends Node
class_name GlobalPlayer

var dps_damage: float = 0.0
var click_damage: float = 1.0
var gold_resource: float = 0.0
var scrap_resource: float = 0.0


func _ready():
	for i in range(1, 101):
		var gold = get_gold_range(i)
		print("Level %d | Gold Range: %s" % [i, str(gold)])

	# Exemplo de nível alto
	var high_level = 200
	print("Level %d | Gold Range: %s" % [high_level, str(get_gold_range(high_level))])


func improve_gold() -> void:
	var gold_range = get_gold_range(World.level)
	
	gold_resource += randi_range(gold_range[0], gold_range[1])
	get_tree().call_group("main_scene", "update_label")


func get_gold_range(level: int) -> Array:
	# Parâmetros ajustáveis
	var base_gold: float = 13.5
	var growth_rate: float = 1.17
	var exponent: float = 0.85
	var variance: float = 0.08  # 8% pra gerar um range

	# Calcula o ouro médio para o level atual
	var mean_gold: float = base_gold * pow(growth_rate, pow(level - 1, exponent))

	# Gera um range com leve variação aleatória
	var min_gold: int = int(mean_gold * (1.0 - variance))
	var max_gold: int = int(mean_gold * (1.0 + variance))
	
	return [min_gold, max_gold]
