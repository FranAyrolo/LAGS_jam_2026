extends CharacterBody2D

@export var SPEED = 100000.0


func _ready() -> void:
	Global.item_seleccionado.connect(_on_item_seleccionado)


func _physics_process(delta: float) -> void:
	var direction := Vector2(Input.get_axis("INPUT_LEFT", "INPUT_RIGHT"), Input.get_axis("INPUT_UP", "INPUT_DOWN"))
	velocity = direction * SPEED * delta
	if velocity.distance_to(Vector2.ZERO) <= 0.001:
		$Sprite.play("Idle")
	else:
		$Sprite.play("Movimiento")
	velocity.move_toward(Vector2.ZERO, SPEED)
	if direction.x != 0:
		%Sprite.flip_h = direction.x < 0
	
	move_and_slide()


func _on_item_seleccionado(item: ItemResource) -> void:
	%Inventario.agregar_item(item)
