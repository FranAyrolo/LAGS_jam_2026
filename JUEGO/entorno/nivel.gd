extends Node2D


func _ready() -> void:
	#%TimerReloj.timeout.connect(avanzar_tiempo_reloj)
	Global.request_navmap_rid.connect(_on_navmap_rid_request)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("INPUT_ESC"):
		get_tree().quit()

func avanzar_tiempo_reloj() -> void:
	pass

func _on_navmap_rid_request(node: Node, type: BaseCryptid.CryptidType) -> void:
	match type:
		BaseCryptid.CryptidType.CARPINCHO:
			node.navigation_map_rid = $NavigationRegion2D.get_rid()
		BaseCryptid.CryptidType.DEFAULT:
			push_error("Cryptido de tipo default!!")

func _on_mini_juego_mate_mate_listo() -> void:
	if has_node("Objetos/Mate"):
		return  # ya hay uno, no crea otro
	var mate = preload("res://JUEGO/items/item_objeto.tscn").instantiate()
	mate.name = "Mate"
	mate.item_data = preload("res://JUEGO/items/mate.tres")
	mate.global_position = Vector2(2000, -1048)
	$Objetos.add_child(mate)
