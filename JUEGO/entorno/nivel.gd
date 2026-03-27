extends Node2D


func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	Global.request_navmap_rid.connect(_on_navmap_rid_request)


func _on_timer_timeout() -> void:
	pass

func _on_navmap_rid_request(node: Node, type: Global.CryptidType) -> void:
	match type:
		Global.CryptidType.CARPINCHO:
			node.navigation_map_rid = $NavigationRegion2D.get_rid()
		Global.CryptidType.DEFAULT:
			push_error("Cryptido de tipo default!!")
