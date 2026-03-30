extends Node2D

var juego_terminado: bool = false

func _ready() -> void:
	%MenuIngame.visible = false
	Global.request_navmap_rid.connect(_on_navmap_rid_request)
	%Player.reloj_terminado.connect(pasar_pantalla_final.bind(true))
	#%ControlCentral.fin_de_juego_derrota.connect(pasar_pantalla_final.bind(false))
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


func pasar_pantalla_final(victoria: bool) -> void:
	var mensaje: String
	if victoria:
		mensaje = "[tornado radius=5.0 freq=3.0 connected=1][shake rate=50.0 level=15 connected=1][font_size=60]G A N A S T E[/font_size][/shake][/tornado]
[font_size=30]Llegaste al final del día sin que se alteren los seres.[/font_size]
	"
	else:
		mensaje = "[tornado radius=5.0 freq=3.0 connected=1][shake rate=50.0 level=15 connected=1][font_size=60]P E R D I S T E
[/font_size][/shake][/tornado]
[font_size=30]Uno o más seres entraron en código negro y se rompió la realidad.[/font_size]"
	_mostrar_menu()
	%TextoFinDeJuego.text = mensaje
	%TextoFinDeJuego.visible = true
	


func _on_control_central_fin_de_juego_derrota() -> void:
	if juego_terminado == false:
		juego_terminado = true
		pasar_pantalla_final(false)
