extends Area2D

var jugador_cerca: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("INPUT_INTERACT"):
		if %Player.estado_actual == Player.EstadoPelo.VERDE:
			return 
		%Player.estado_actual = Player.EstadoPelo.VERDE
		_spawnear_pelo(%Player.global_position)

func _spawnear_pelo(pos: Vector2) -> void:
	var pelo = preload("res://JUEGO/items/item_objeto.tscn").instantiate()
	pelo.name = "PilaPelo"
	pelo.item_data = preload("res://JUEGO/items/Pelo.tres")
	get_tree().get_root().get_node("Nivel/Objetos").add_child(pelo)
	pelo.global_position = %Player.position

func _on_body_entered(body) -> void:
	if body is Player:
		jugador_cerca = true

func _on_body_exited(body) -> void:
	if body is Player:
		jugador_cerca = false
