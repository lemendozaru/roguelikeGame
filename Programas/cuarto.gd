class_name Cuarto
extends StaticBody2D

enum Direction
{
	NORTE,
	SUR,
	ESTE,
	OESTE
}

@export var puertas_siempre_abiertas : bool = false

@onready var entrada_norte : EntradaCuarto = $Entrance_North
@onready var entrada_sur : EntradaCuarto = $Entrance_South
@onready var entrada_este : EntradaCuarto = $Entrance_East
@onready var entrada_oeste : EntradaCuarto = $Entrance_West

var enemigos_presentes : int

func _ready ():
	GlobalSignals.OnDerrotarEnemigo.connect(_on_enemigo_derrotado)
	
	for child in get_children():
		if child is Enemigo:
			enemigos_presentes += 1
			child.initialize(self)

func initialize ():
	pass

func colocar_vecino (direccion_vecino : Direction, cuarto_vecino : Cuarto):
	if direccion_vecino == Direction.NORTE:
		entrada_norte.colocar_vecino(cuarto_vecino)
	elif direccion_vecino == Direction.SUR:
		entrada_sur.colocar_vecino(cuarto_vecino)
	elif direccion_vecino == Direction.ESTE:
		entrada_este.colocar_vecino(cuarto_vecino)
	elif direccion_vecino == Direction.OESTE:
		entrada_oeste.colocar_vecino(cuarto_vecino)

# called when the player enters the room
func player_enter (direccion_entrada : Direction, jugador : CharacterBody2D, primer_cuarto : bool = false):
	# set their position based on where they entered from
	if direccion_entrada == Direction.NORTE:
		jugador.global_position = entrada_norte.generar_jugador.global_position
	elif direccion_entrada == Direction.SUR:
		jugador.global_position = entrada_sur.generar_jugador.global_position
	elif direccion_entrada == Direction.ESTE:
		jugador.global_position = entrada_este.generar_jugador.global_position
	elif direccion_entrada == Direction.OESTE:
		jugador.global_position = entrada_oeste.player_spawn.global_position
	
	# if this is the first room, spawn the player in the middle
	if primer_cuarto:
		jugador.global_position = global_position
	
	GlobalSignals.OnJugadorEntra.emit(self)
	
	# close the doors if there are enemies to defeat
	if enemigos_presentes > 0 and not puertas_siempre_abiertas:
		cerrar_puertas()
	else:
		abrir_puertas()

func _on_derrotar_enemigo (_enemigo):
	pass

func abrir_puertas ():
	entrada_norte.abrir_puerta.call_deferred()
	entrada_sur.abrir_puerta.call_deferred()
	entrada_este.abrir_puerta.call_deferred()
	entrada_oeste.abrir_puerta.call_deferred()

func cerrar_puertas ():
	entrada_norte.cerrar_puerta.call_deferred()
	entrada_sur.cerrar_puerta.call_deferred()
	entrada_este.cerrar_puerta.call_deferred()
	entrada_oeste.cerrar_puerta.call_deferred()

func _on_enemigo_derrotado (enemigo : Enemigo):
	if enemigo.get_parent() == self:
		enemigos_presentes -= 1
		
		if enemigos_presentes <= 0:
			abrir_puertas()
