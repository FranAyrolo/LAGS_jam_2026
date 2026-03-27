extends Node

signal item_seleccionado(item: ItemResource)


func get_player_global_position() -> Vector2:
	var grupo: Array[Node] = get_tree().get_nodes_in_group("grupo_jugador")
	assert(grupo.size() > 0)
	return grupo[0].global_position
