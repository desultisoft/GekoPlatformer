extends Node2D

@export var grow_time = 1.0
@onready var patterns = preload("res://Scenes/Tree/tree_patterns.gd")

func _ready():
	var offset = Vector2(0,0)
	offset = pattern_builder(patterns.stump, Vector2(0,0))
	offset = pattern_builder(patterns.trunk, Vector2(0,-3))
	offset = pattern_builder(patterns.cap, Vector2(0,-10))

func pattern_builder(pattern, offset):
	var coords = pattern["coords"]
	for i in range(len(coords)):
		for j in range(len(coords[i])):
			var x = coords[i][j][0]
			var y = coords[i][j][1]
			var atlas_pos = Vector2(x, y)
			var game_pos = atlas_pos - pattern["start_tile"] + offset
			$Trunk.set_cell(0, game_pos, 1, atlas_pos)
			
	var new_offset = offset + pattern["start_tile"] - pattern["end_tile"]
	new_offset = pattern["start_tile"] - pattern["end_tile"] - Vector2(0, -1)
	print(new_offset)
	return new_offset
