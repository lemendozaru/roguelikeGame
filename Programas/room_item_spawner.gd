extends Node2D

@export var item_scenes : Array[PackedScene]

func _ready ():
	var item = item_scenes[randi_range(0, len(item_scenes) - 1)].instantiate()
	add_child(item)
