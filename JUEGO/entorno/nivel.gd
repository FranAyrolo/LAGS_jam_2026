extends Node2D


func _ready() -> void:
	%MenuIngame.visible = false
	Global.request_navmap_rid.connect(_on_navmap_rid_request)
	%Continuar.pressed.connect(_mostrar_menu)
	%Opciones.pressed.connect(_on_opciones_pressed)
	%Creditos.pressed.connect(_on_creditos_pressed)
	%Salir.pressed.connect(get_tree().quit)
	%Volver.pressed.connect(_on_volver_pressed)


func _process(_delta: float) -> void:
	%Volver.visible = %CreditosIngame.visible || %OpcionesIngame.visible
	if Input.is_action_just_pressed("INPUT_ESC"):
		_mostrar_menu()


func _mostrar_menu() -> void:
	%MenuIngame.visible = not %MenuIngame.visible
	if %MenuIngame.visible:
		%CreditosIngame.visible = false
		%OpcionesIngame.visible = false
	%Player.habilitar_input = not %MenuIngame.visible


func _on_opciones_pressed() -> void:
	%MenuIngame.visible = false
	%OpcionesIngame.visible = true


func _on_creditos_pressed() -> void:
	%MenuIngame.visible = false
	%CreditosIngame.visible = true


func _on_volver_pressed() -> void:
	%CreditosIngame.visible = false
	%OpcionesIngame.visible = false
	%MenuIngame.visible = true

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
