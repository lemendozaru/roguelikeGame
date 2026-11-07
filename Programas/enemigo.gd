class_name Enemigo
extends CharacterBody2D

@export var vida_actual : int = 4
@export var vida_max : int = 4
@export var velocidad_mov : float = 20

@export var nivel_ataque : int = 1
@export var rango_ataque : float = 10
@export var cadencia_ataque : float = 0.5
var tiempo_ultimo_ataque : float

@onready var sprite : Sprite2D = $Sprite

var cuarto : Cuarto
var es_activo : bool = false
var jugador : CharacterBody2D

var direccion_jugador : Vector2
var distancia_al_jugador : float

func _ready ():
	jugador = get_tree().get_first_node_in_group("Jugador")
	GlobalSignals.OnJugadorEntra.connect(_on_jugador_entra)

func initialize (dentro_cuarto : Cuarto):
	es_activo = false
	cuarto = dentro_cuarto

func _on_jugador_entra (cuarto_jugador : Cuarto):
	es_activo = cuarto_jugador == cuarto

func _physics_process(_delta):
	if not es_activo or not jugador:
		return
	
	direccion_jugador = global_position.direction_to(jugador.global_position)
	distancia_al_jugador = global_position.distance_to(jugador.global_position)
	
	sprite.flip_h = direccion_jugador.x < 0
	
	if distancia_al_jugador < rango_ataque:
		_intentar_ataque()
		return
	
	velocity = direccion_jugador * velocidad_mov
	move_and_slide()

func _intentar_ataque ():
	if Time.get_unix_time_from_system() - tiempo_ultimo_ataque < cadencia_ataque:
		return
	
	tiempo_ultimo_ataque = Time.get_unix_time_from_system()
	
	jugador.recibir_dano(nivel_ataque)

func recibir_dano (cantidad : int):
	vida_actual -= cantidad
	
	_damage_flash()
	$DamagedSound.play()
	
	if vida_actual <= 0:
		die()

func _damage_flash ():
	visible = false
	await get_tree().create_timer(0.07).timeout
	visible = true

func die ():
	GlobalSignals.OnDerrotarEnemigo.emit(self)
	queue_free()
