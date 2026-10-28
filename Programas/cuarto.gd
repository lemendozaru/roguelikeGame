class_name Cuarto
extends StaticBody2D

enum Direccion
{
	NORTE,
	OESTE,
	ESTE,
	SUR	
}

# Determina si las puertas deberían estar abiertas
@export var puertas_siempre_abiertas : bool = false

# Referencia a las entradas
@onready var entrada_norte : EntradaCuarto = $EntradaNorte
@onready var entrada_sur : EntradaCuarto = $EntradaSur
@onready var entrada_oeste : EntradaCuarto = $EntradaOeste
@onready var entrada_este : EntradaCuarto = $EntradaEste

# Registra el número de enemigos presentes
var enemigos_presentes : int

func _ready():
	pass
	
func inicializar():
	pass
	
func colocar_vecino(direccion_vecino : Direccion, cuarto_vecino : Cuarto):
	if direccion_vecino == Direccion.NORTE:
		entrada_norte.colocar_vecino(cuarto_vecino)
	elif direccion_vecino == Direccion.SUR:
		entrada_sur.colocar_vecino(cuarto_vecino)
	elif direccion_vecino == Direccion.OESTE:
		entrada_oeste.colocar_vecino(cuarto_vecino)
	elif direccion_vecino == Direccion.ESTE:
		entrada_este.colocar_vecino(cuarto_vecino)
	
func jugador_entra(direccion_entrada : Direccion, jugador : CharacterBody2D, primer_cuarto : bool = false):
	if direccion_entrada == Direccion.NORTE:
		jugador.global_position = entrada_norte.jugador_spawn.global_position
	elif direccion_entrada == Direccion.SUR:
		jugador.global_position = entrada_sur.jugador_spawn.global_position
	elif direccion_entrada == Direccion.OESTE:
		jugador.global_position = entrada_oeste.jugador_spawn.global_position
	elif direccion_entrada == Direccion.ESTE:
		jugador.global_position = entrada_este.jugador_spawn.global_position
		
	if primer_cuarto:
		jugador.global_position = global_position
		
	if enemigos_presentes > 0 and not puertas_siempre_abiertas:
		cerrar_puertas()
	else:
		abrir_puertas()
	
func _enemigo_derrotado(enemigo):
	pass
	
func abrir_puertas():
	entrada_norte.abrir_puerta()
	entrada_sur.abrir_puerta()
	entrada_oeste.abrir_puerta()
	entrada_este.abrir_puerta()
	
func cerrar_puertas():
	entrada_norte.cerrar_puerta()
	entrada_sur.cerrar_puerta()
	entrada_oeste.cerrar_puerta()
	entrada_este.cerrar_puerta()
		
	
