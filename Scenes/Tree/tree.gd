extends Node2D

@export var grow_time = 1.0
@onready var patterns = preload("res://Scenes/Tree/tree_patterns.gd")

func _ready():
	var grow_point = Vector2(0,0)
	grow_point = pattern_builder_fast(patterns.stump, grow_point)
	grow_point = await pattern_builder_slow(patterns.trunk, grow_point, 1)

func pattern_builder_slow(pattern, offset, pause):
	var coords = pattern["coords"]
	for i in range(len(coords)-1,-1, -1):
		var game_pos
		for j in range(len(coords[i])):
			var x = coords[i][j][0]
			var y = coords[i][j][1]
			var atlas_pos = Vector2(x, y)
			game_pos = atlas_pos - pattern["start_tile"] + offset
			$Trunk.set_cell(0, game_pos, 1, atlas_pos)
		pattern_builder_fast(patterns.cap, game_pos+Vector2(-1,-1))
		await get_tree().create_timer(pause).timeout
	var relative_change = pattern["end_tile"]-pattern["start_tile"]
	var new_offset = offset + relative_change + Vector2(0, -1) #add 1 above
	return new_offset


func pattern_builder_fast(pattern, offset):
	var coords = pattern["coords"]
	for i in range(len(coords)-1,-1, -1):
		for j in range(len(coords[i])):
			var x = coords[i][j][0]
			var y = coords[i][j][1]
			var atlas_pos = Vector2(x, y)
			var game_pos = atlas_pos - pattern["start_tile"] + offset
			$Trunk.set_cell(0, game_pos, 1, atlas_pos)
	var relative_change = pattern["end_tile"]-pattern["start_tile"]
	var new_offset = offset + relative_change + Vector2(0, -1) #add 1 above
	return new_offset
