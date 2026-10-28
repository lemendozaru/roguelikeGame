class_name  EntradaCuarto
extends Node2D

@export var direccion : Cuarto.Direccion = Cuarto.Direccion.NORTE

@onready var barrera : StaticBody2D = $Barrera
@onready var barrera_collider : CollisionShape2D = $Barrera/CollisionShape2D
@onready var puerta : Node2D = $Puerta
@onready var puerta_cerrada : StaticBody2D = $Puerta/PuertaCerrada
@onready var puerta_cerrada_collider : CollisionShape2D = $Puerta/PuertaCerrada/CollisionShape2D
@onready var jugador_spawn : Node2D = $JugadorSpawn
@onready var disparador_salida : Area2D = $DisparadorSalida
var vecino : Cuarto

func _ready():
	disparador_salida.body_entered.connect(_on_body_entered_disparador_salida)
	colocar_barrera(true)
	
func colocar_vecino(cuarto_vecino : Cuarto):
	vecino = cuarto_vecino
	colocar_barrera(false)
	
func colocar_barrera(colocar : bool):
	barrera.visible = colocar
	barrera_collider.disabled = !colocar
	puerta.visible = !colocar
	
func abrir_puerta():
	if barrera.visible:
		return
	puerta_cerrada.visible = false
	puerta_cerrada_collider.disabled = true
	
func cerrar_puerta():
	if barrera.visible:
		return
	puerta_cerrada.visible = true
	puerta_cerrada_collider.visible = false
	
	
func _on_body_entered_disparador_salida(body):
	pass
	
func obtener_direccion_vecino() -> Cuarto.Direccion:
	if direccion == Cuarto.Direccion.NORTE:
		return Cuarto.Direccion.SUR
	elif direccion == Cuarto.Direccion.SUR:
		return Cuarto.Direccion.NORTE
	elif direccion == Cuarto.Direccion.OESTE:
		return Cuarto.Direccion.ESTE
	else:
		return Cuarto.Direccion.OESTE
	
