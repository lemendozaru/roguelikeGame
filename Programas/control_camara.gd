extends Camera2D

func _ready ():
	GlobalSignals.OnJugadorEntra.connect(_on_jugador_entra)

func _on_jugador_entra (cuarto : Cuarto):
	global_position = cuarto.global_position
