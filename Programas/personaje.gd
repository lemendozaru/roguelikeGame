extends CharacterBody2D

# Tiempo entre disparos
@export var cadencia : float = 0.4
# Almacena el tiempo desde el último disparo
var marca_tiempo : float

# Precarga
var escena_proyectil : PackedScene = preload("res://Escenas/Proyectiles/proyectil.tscn")

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
	
	if Input.is_action_pressed("atacar"):
		# Establecemos un tiempo de recarga entre disparos
		if Time.get_unix_time_from_system() - marca_tiempo > cadencia:
			_disparar()
			
func _disparar():
	marca_tiempo = Time.get_unix_time_from_system()
	
	# Genera un proyectil en el cañón y lo orienta con base en este
	var bala = escena_proyectil.instantiate()
	get_tree().root.add_child(bala)
	bala.global_position = cannon.global_position
	bala.rotation = pivote_arma.rotation
	
	# Etiquetamos al proyectil para que no dañe a quien lo disparó
	bala.propietario = self
	
func herido(cantidad : int):
	pass
