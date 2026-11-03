extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Escucha cambios en el cuarto via el bus global de eventos
	SenalesGlobales.OnJugadorEntraCuarto.connect(_on_jugador_entra_cuarto)
	
func _on_jugador_entra_cuarto(cuarto : Cuarto):
	# Apunta la cámara al centro del cuarto al que se ha entrado
	global_position = cuarto.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
