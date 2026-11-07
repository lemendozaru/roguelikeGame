class_name RoomGeneration
extends Node

@export var map_size : int = 7
@export var rooms_to_generate : int = 12
var room_count : int = 0
var map : Array[bool]
var cuartos : Array[Cuarto]
var room_pos_offset : float = 160

var first_room_x : int = 3
var first_room_y : int = 3
var first_room : Cuarto

var room_scene : PackedScene = preload("res://Escenas/Cuartos/room_template.tscn")

@export var first_room_scene : PackedScene
@export var boss_room : PackedScene
@export var room_scenes : Array[PackedScene]

@export var player : CharacterBody2D

func _ready ():
	_generate()
	
	# room layout preview
	#for x in range(map_size):
		#var line : String
		#for y in range(map_size):
			#line += "# " if _get_map(x, y) else "  "
		#print(line)

func _generate ():
	room_count = 0
	map.resize(map_size * map_size)
	
	# start the check room chain at the center of the grid
	_check_room(first_room_x, first_room_y, Vector2.ZERO, true)
	
	# once we've defined our map, spawn in the room scenes
	_instantiate_rooms()

func _check_room (x : int, y : int, desired_direction : Vector2, is_first_room : bool = false):
	# return if we've created enough rooms
	if room_count >= rooms_to_generate:
		return
	
	# return if out of bounds
	if x < 0 or x > map_size - 1 or y < 0 or y > map_size - 1:
		return
	
	# return if room already exists
	if _get_map(x, y) == true:
		return
	
	room_count += 1
	_set_map(x, y, true)
	
	# define the directions we want to expand in
	var go_north : bool = randf() > (0.2 if desired_direction == Vector2.UP else 0.8)
	var go_south : bool = randf() > (0.2 if desired_direction == Vector2.DOWN else 0.8)
	var go_east : bool = randf() > (0.2 if desired_direction == Vector2.RIGHT else 0.8)
	var go_west : bool = randf() > (0.2 if desired_direction == Vector2.LEFT else 0.8)
	
	# continue the check room chain in those directions
	if go_north or is_first_room:
		_check_room(x, y - 1, Vector2.UP if is_first_room else desired_direction)
	if go_south or is_first_room:
		_check_room(x, y + 1, Vector2.DOWN if is_first_room else desired_direction)
	if go_east or is_first_room:
		_check_room(x + 1, y, Vector2.RIGHT if is_first_room else desired_direction)
	if go_west or is_first_room:
		_check_room(x - 1, y, Vector2.LEFT if is_first_room else desired_direction)

func _instantiate_rooms ():
	var boss_room_pos : Vector2 = _decide_boss_room()
	
	# instantiate each room scene at their designated position
	for x in range(map_size):
		for y in range(map_size):
			if _get_map(x, y) == false:
				continue
			
			var cuarto : Cuarto
			var is_first_room : bool = first_room_x == x and first_room_y == y
			
			if is_first_room:
				cuarto = first_room_scene.instantiate()
			elif x == boss_room_pos.x and y == boss_room_pos.y:
				cuarto = boss_room.instantiate()
			else:
				cuarto = room_scenes[randi_range(0, len(room_scenes) - 1)].instantiate()
			
			get_tree().root.get_node("/root/Main").add_child.call_deferred(cuarto)
			cuartos.append(cuarto)
			
			cuarto.global_position = Vector2(x, y) * room_pos_offset
			
			if is_first_room:
				first_room = cuarto
			
			cuarto.initialize()
	
	# set room neighbors
	for cuarto in cuartos:
		var map_pos : Vector2 = _get_map_index(cuarto)
		var x = map_pos.x
		var y = map_pos.y
		
		if y > 0 and _get_map(x, y - 1):
			cuarto.colocar_vecino.call_deferred(Cuarto.Direction.NORTE, get_room_from_map(x, y - 1))
		if y < map_size - 1 and _get_map(x, y + 1):
			cuarto.colocar_vecino.call_deferred(Cuarto.Direction.SUR, get_room_from_map(x, y + 1))
		if x < map_size - 1 and _get_map(x + 1, y):
			cuarto.colocar_vecino.call_deferred(Cuarto.Direction.ESTE, get_room_from_map(x + 1, y))
		if x > 0 and _get_map(x - 1, y):
			cuarto.colocar_vecino.call_deferred(Cuarto.Direction.OESTE, get_room_from_map(x - 1, y))
	
	# put the player in the first room
	first_room.player_enter.call_deferred(Cuarto.Direction.NORTE, player, true)

func _decide_boss_room () -> Vector2:
	var i = 0
	
	while i < 100:
		var x = randi_range(0, map_size - 1)
		var y = randi_range(0, map_size - 1)
		
		if first_room_x == x and first_room_y == y:
			continue
		
		if _get_map(x, y):
			return Vector2(x, y)
	
	return Vector2.ZERO

func get_room_from_map (x : int, y : int) -> Cuarto:
	for cuarto in cuartos:
		var pos = _get_map_index(cuarto)
		
		if pos.x != x or pos.y != y:
			continue
		
		return cuarto
	
	return null

func _get_map_index (cuarto : Cuarto) -> Vector2i:
	return Vector2i(cuarto.global_position / room_pos_offset)

func _get_map (x : int, y : int) -> bool:
	return map[x + y * map_size]

func _set_map (x : int, y : int, value : bool):
	map[x + y * map_size] = value
