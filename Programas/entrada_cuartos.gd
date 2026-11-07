class_name EntradaCuarto
extends Node2D

@export var direccion : Cuarto.Direction = Cuarto.Direction.NORTE

@onready var barrera : StaticBody2D = $Barrier
@onready var collider_barrera : CollisionShape2D = $Barrier/CollisionShape2D

@onready var puerta : Node2D = $Door
@onready var puerta_cerrada : StaticBody2D = $Door/Door_Shut
@onready var collider_puerta_cerrada : CollisionShape2D = $Door/Door_Shut/CollisionShape2D

@onready var generar_jugador : Node2D = $PlayerSpawn
@onready var evento_salida : Area2D = $ExitTrigger

var vecino : Cuarto

func _ready ():
	evento_salida.body_entered.connect(_on_body_entered_exit_trigger)
	alternar_barrera(true)

func colocar_vecino (cuarto_vecino : Cuarto):
	vecino = cuarto_vecino
	alternar_barrera(false)

func alternar_barrera (alternar : bool):
	barrera.visible = alternar
	collider_barrera.disabled = !alternar
	
	puerta.visible = !alternar

func abrir_puerta ():
	if barrera.visible:
		return
	
	puerta_cerrada.visible = false
	collider_puerta_cerrada.disabled = true

func cerrar_puerta ():
	if barrera.visible:
		return
	
	puerta_cerrada.visible = true
	collider_puerta_cerrada.disabled = false

func _on_body_entered_exit_trigger (body):
	if body.is_in_group("Jugador"):
		vecino.player_enter(_obtener_direccion_entrada_vecino(), body)

func _obtener_direccion_entrada_vecino () -> Cuarto.Direction:
	if direccion == Cuarto.Direction.NORTE:
		return Cuarto.Direction.SUR
	elif direccion == Cuarto.Direction.SUR:
		return Cuarto.Direction.NORTE
	elif direccion == Cuarto.Direction.ESTE:
		return Cuarto.Direction.OESTE
	else:
		return Cuarto.Direction.ESTE
