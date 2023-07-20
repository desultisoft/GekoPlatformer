extends Node2D

@export var grow_time = 1.0
@onready var patterns = preload("res://Scenes/Tree/tree_patterns.gd")

func _ready():
	var grow_point = Vector2(0,0)
	grow_point = pattern_builder(patterns.stump, grow_point)
	grow_point = pattern_builder(patterns.trunk, grow_point)
	grow_point = pattern_builder(patterns.cap, grow_point)

func pattern_builder(pattern, offset):
	var coords = pattern["coords"]
	for i in range(len(coords)):
		for j in range(len(coords[i])):
			var x = coords[i][j][0]
			var y = coords[i][j][1]
			var atlas_pos = Vector2(x, y)
			var game_pos = atlas_pos - pattern["start_tile"] + offset
			$Trunk.set_cell(0, game_pos, 1, atlas_pos)
	var relative_change = pattern["end_tile"]-pattern["start_tile"]
	var new_offset = offset + relative_change + Vector2(0, -1) #add 1 above
	return new_offset
