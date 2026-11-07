extends Area2D

@export var base_speed : float = 100
var owner_character : CharacterBody2D

func _process (delta):
	translate(-transform.y * base_speed * delta)

func _on_body_entered(body):
	if body == owner_character:
		return
	
	if body.has_method("recibir_dano"):
		body.recibir_dano(1)
	
	queue_free()

func _on_timer_timeout():
	queue_free()
