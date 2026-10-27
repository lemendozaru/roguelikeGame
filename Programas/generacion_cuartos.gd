class_name  GeneracionCuarto
extends Node

@export var talla_mapa : int = 7
@export var cuartos_a_generar : int = 12
var conteo_cuartos : int = 0
var mapa : Array[bool]
var cuartos : Array[Cuarto]
var cuartos_pos_desfase : float = 160

var primer_cuarto_x : int = 3
var primer_cuarto_y : int = 3
var primer_cuarto : Cuarto

# Cargamos nuestra plantilla de cuarto
var escena_cuarto : PackedScene = preload("res://Escenas/Cuartos/plantilla_cuarto.tscn")

@export var jugador : CharacterBody2D

# Inicializa el proceso de generación
func _ready():
	_generar()
	
# Configura el mapa e inicia la generación de cuartos
func _generar():
	# Iniciamos conteo en 0
	conteo_cuartos = 0
	# Redimensionamos el mapa
	mapa.resize(talla_mapa * talla_mapa)
	
	# Inicia el chequeo de cuartos en el centro de la malla
	_checar_cuarto(primer_cuarto_x, primer_cuarto_y, Vector2.ZERO, true)
	
	# Una vez definido el mapa, instancia cuartos
	_instanciar_cuartos()
	
# Verifica y coloca cuartos recursivamente
func _checar_cuarto(x : int, y : int, direccion_deseada : Vector2, primer_cuarto : bool = false):
	# Conteo excedido
	if conteo_cuartos >= cuartos_a_generar:
		return
	
	# Tamaño del mapa sobrepasado
	if x < 0 or x > talla_mapa - 1 or y < 0 or y > talla_mapa - 1:
		return
		
	# Si el cuarto ya existe
	if _obtener_mapa(x, y) == true:
		return
		
	conteo_cuartos += 1
	
	_poner_mapa(x, y, true)
	
	var hacia_norte : bool = randf() > (0.2 if direccion_deseada == Vector2.UP else 0.8)
	var hacia_oeste : bool = randf() > (0.2 if direccion_deseada == Vector2.LEFT else 0.8)
	var hacia_este : bool = randf() > (0.2 if direccion_deseada == Vector2.RIGHT else 0.8)
	var hacia_sur : bool = randf() > (0.2 if direccion_deseada == Vector2.DOWN else 0.8)
	
	if hacia_norte or primer_cuarto:
		_checar_cuarto(x, y - 1, Vector2.UP if primer_cuarto else direccion_deseada)
	if hacia_oeste or primer_cuarto:
		_checar_cuarto(x - 1, y, Vector2.LEFT if primer_cuarto else direccion_deseada)
	if hacia_este or primer_cuarto:
		_checar_cuarto(x + 1, y, Vector2.RIGHT if primer_cuarto else direccion_deseada)
	if hacia_sur or primer_cuarto:
		_checar_cuarto(x, y - 1, Vector2.DOWN if primer_cuarto else direccion_deseada)
	
# Instancia los cuartos
func _instanciar_cuartos():
	for x in range(talla_mapa):
		for y in range(talla_mapa):
			if _obtener_mapa(x,y) == false:
				continue
			
			var cuarto : Cuarto = escena_cuarto.instantiate()
			get_tree().root.add_child.call_deferred(cuarto)
			cuartos.append(cuarto)
			
			cuarto.global_position = Vector2(x,y) * cuartos_pos_desfase
	
func _obtener_mapa(x : int, y : int) -> bool:
	return mapa[x + y * talla_mapa]
	
func _poner_mapa(x : int, y : int, value : bool):
	mapa[x + y * talla_mapa] = value
