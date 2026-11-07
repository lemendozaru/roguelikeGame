extends GridContainer

var room_gen : RoomGeneration

var icons : Array[TextureRect]

var room_texture : Texture = preload("res://Sprites/Items/minimap_room.tres")
var player_room_texture : Texture = preload("res://Sprites/Items/minimap_player_room.tres")

func _ready ():
	GlobalSignals.OnJugadorEntra.connect(_on_jugador_entra_cuarto)

func _on_jugador_entra_cuarto (cuarto : Cuarto):
	if not room_gen:
		room_gen = get_node("/root/Main/RoomGeneration")
		
		for child in get_children():
			if child is TextureRect:
				icons.append(child)
	
	for x in range(room_gen.map_size):
		for y in range(room_gen.map_size):
			var r = room_gen.get_room_from_map(x, y)
			var i = x + y * room_gen.map_size
			
			if i >= len(icons):
				continue
			
			if not r:
				icons[i].texture = null
			elif r == cuarto:
				icons[i].texture = player_room_texture
			else:
				icons[i].texture = room_texture
