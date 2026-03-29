extends Area2D


@export var minijuego: Control
var jugador_cerca: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if jugador_cerca and Input.is_action_just_pressed("INPUT_INTERACT"):
		minijuego.visible = !minijuego.visible
		if minijuego.visible:
			%Player.set_physics_process(false)
			%Player.set_process(false)
		else:
			%Player.set_physics_process(true)
			%Player.set_process(true)
			minijuego.resetear()

func _on_body_entered(body) -> void:
	if body is Player:
		jugador_cerca = true

func _on_body_exited(body) -> void:
	if body is Player:
		jugador_cerca = false
