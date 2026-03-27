extends Node

enum CryptidType {DEFAULT, CARPINCHO}

@warning_ignore_start("unused_signal")
signal item_seleccionado(item: ItemResource, objeto_item: ObjetoItem)
signal request_navmap_rid(caller_node: Node, type: CryptidType)


func get_player_global_position() -> Vector2:
	var grupo: Array[Node] = get_tree().get_nodes_in_group("grupo_jugador")
	assert(grupo.size() > 0)
	return grupo[0].global_position
