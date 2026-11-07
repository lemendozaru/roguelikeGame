extends Area2D

@export var boss : Enemigo
@export var next_level : PackedScene

func _ready ():
	GlobalSignals.OnDerrotarEnemigo.connect(_on_derrotar_enemigo)
	visible = false
	$CollisionShape2D.disabled = true

func _on_derrotar_enemigo (enemigo : Enemigo):
	if enemigo != boss:
		return
	
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)

func _on_body_entered(body):
	if not body.is_in_group("Jugador"):
		return
	
	get_tree().change_scene_to_packed.call_deferred(next_level)
