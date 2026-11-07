extends GridContainer

var full_heart : Texture = preload("res://Sprites/Items/heart_full.tres")
var empty_heart : Texture = preload("res://Sprites/Items/heart_empty.tres")

var heart_icons : Array[TextureRect]

func _init ():
	GlobalSignals.OnPlayerUpdateHealth.connect(_update_ui)

func _ready ():
	for child in get_children():
		if child is TextureRect:
			heart_icons.append(child)

func _update_ui (cur_hp : int, max_hp : int):
	for i in len(heart_icons):
		if i >= max_hp:
			heart_icons[i].visible = false
			continue
		
		heart_icons[i].visible = true
		
		if i < cur_hp:
			heart_icons[i].texture = full_heart
		else:
			heart_icons[i].texture = empty_heart
