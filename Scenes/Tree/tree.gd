extends Node2D


@export var grow_time = 1.0

func _ready():
	var tile_placement = Vector2(0, 0)
	var tile_to_use = Vector2(0,1)
	$Trunk.set_cell(0, tile_placement, 1, tile_to_use)


