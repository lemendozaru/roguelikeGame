extends Area2D

# Controla qué tan rápido se mueve el proyectil
@export var velocidad_base : float = 100
# Referencia a quien disparó el proyectil
var propietario : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Mueve el proyectil siguiendo su propio eje vertical
func _process(delta: float) -> void:
	# Movimiento hacia "arriba", la rotación determina la dirección
	translate(-transform.y * velocidad_base * delta)


# Cuando ocurre una colisión verifica si fue con el propietario y si no, 
# causa daño y se autodestruye
func _on_body_entered(body: Node2D) -> void:
	# Ignora al propietario que disparó
	if body == propietario:
		return
		
	# Cualquier cuerpo con herido() puede ser dañado
	if body.has_method("herido"):
		body.herido(1)
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
