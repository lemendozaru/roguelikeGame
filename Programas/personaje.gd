extends CharacterBody2D

@export var velocidad_movimiento : float = 50

@onready var sprite : Sprite2D = $Sprite
@onready var pivote_arma : Node2D = $Arma
@onready var cannon : Node2D = $Arma/Cannon

func _physics_process(delta: float):
	var entrada_mover : Vector2 = Input.get_vector("mover_izquierda","mover_derecha","mover_arriba","mover_abajo")
	velocity = entrada_mover * velocidad_movimiento
	move_and_slide()

func _process(delta: float) -> void:
	var posicion_raton : Vector2 = get_global_mouse_position()
	var direccion_raton : Vector2 = (posicion_raton - global_position).normalized()
	pivote_arma.rotation_degrees = rad_to_deg(direccion_raton.angle()) + 90
	
	sprite.flip_h = direccion_raton.x < 0
