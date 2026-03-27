extends Node2D


func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	Global.request_navmap_rid.connect(_on_navmap_rid_request)
	$DepositoDeObjetos.agregar_objeto_aceptable("MAte")


func _on_timer_timeout() -> void:
	#$Carpincho.set_movement_target(%Player.global_position)
	pass

func _on_navmap_rid_request(node: Node, type: Global.CryptidType) -> void:
	match type:
		Global.CryptidType.CARPINCHO:
			node.navigation_map_rid = $NavigationRegion2D.get_rid()
		Global.CryptidType.DEFAULT:
			push_error("Cryptido de tipo default!!")
