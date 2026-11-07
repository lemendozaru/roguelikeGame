extends Area2D

enum ItemType
{
	CURA,
	MAS_CADENCIA,
	MAS_RAPIDEZ
}

@export var type : ItemType
@export var value : float

func _on_body_entered(body):
	if not body.is_in_group("Jugador"):
		return
	
	if type == ItemType.CURA:
		body.heal(int(value))
	elif type == ItemType.MAS_CADENCIA:
		body.shoot_rate -= value
	elif type == ItemType.MAS_RAPIDEZ:
		body.move_speed += value
	
	body.get_node("ItemSound").play()
	
	queue_free()
