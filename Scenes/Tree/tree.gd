extends Node2D


@export var grow_time = 1.0

# Defining bottom middle tile as relative (0,0) position Atlas (22,17)
# going from top left, left to right
const tree_base_pattern ={
	"coords": [
		[[18,16],[19,16],[20,16],[21,16],[22, 16],[23,16],[24,16],[25,16]],
		[[16,17],[17,17],[18,17],[19,17],[20,17],[21,17],[22,17],[23,17],[24,17],[25,17],[26,17],[27,17]],
		[[20,18],[21,18],[23,18]]
	],
	"center_tile": Vector2(22, 17)
} 

func _ready():
	pattern_builder(tree_base_pattern, Vector2(0,0))


func pattern_builder(pattern, offset):
	var coords = pattern["coords"]
	for i in range(len(coords)):
		for j in range(len(coords[i])):
			var x = coords[i][j][0]
			var y = coords[i][j][1]
			var atlas_pos = Vector2(x, y)
			var game_pos = atlas_pos - pattern["center_tile"]+offset
			$Trunk.set_cell(0, game_pos, 1, atlas_pos)


