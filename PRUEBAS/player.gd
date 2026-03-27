extends CharacterBody2D

@export var SPEED = 100000.0
var item_en_mano: ObjetoItem
var offset_objeto_mano := Vector2(100, 50)
var posicion_detector_de_items: Vector2

func _ready() -> void:
	Global.item_seleccionado.connect(_on_item_seleccionado)
	posicion_detector_de_items = %DetectorDeItems.position


func _physics_process(delta: float) -> void:
	var direction := Vector2(Input.get_axis("INPUT_LEFT", "INPUT_RIGHT"), Input.get_axis("INPUT_UP", "INPUT_DOWN"))
	velocity = direction * SPEED * delta
	if velocity.distance_to(Vector2.ZERO) <= 0.001:
		$Sprite.play("Idle")
	else:
		$Sprite.play("Movimiento")
	velocity.move_toward(Vector2.ZERO, SPEED)
	
	#Alinear el sprite y el objeto en la mano
	if direction.x != 0:
		%Sprite.flip_h = direction.x < 0
	
	move_and_slide()


func _process(_delta: float) -> void:
	if item_en_mano:
		if %Sprite.flip_h:
			item_en_mano.global_position = global_position + offset_objeto_mano * Vector2(-1, 1)
		else:
			item_en_mano.global_position = global_position + offset_objeto_mano
	
	if %Sprite.flip_h:
		%DetectorDeItems.position = posicion_detector_de_items * Vector2(-1, 1)
	else:
		%DetectorDeItems.position = posicion_detector_de_items
	
	if Input.is_action_just_pressed("INPUT_INTERACT"):
		soltar_juntar_item()


func soltar_juntar_item() -> void:
	var bodies: Array[Node2D] = %DetectorDeItems.get_overlapping_bodies()
	soltar_item()
	if bodies.size() > 0:
		bodies.filter(func(b): return b is ObjetoItem)
		levantar_item(bodies.pick_random())


func soltar_item() -> void:
	if item_en_mano != null:
		item_en_mano.reparent(get_parent())
		item_en_mano.global_position = %DetectorDeItems.global_position
		item_en_mano.ser_puesto_en_el_piso()
		item_en_mano = null


func levantar_item(objeto_item: RigidBody2D) -> void:
	objeto_item.global_position = global_position
	objeto_item.reparent(self, false)
	item_en_mano = objeto_item
	item_en_mano.ser_juntado()


func _on_item_seleccionado(_item: ItemResource, objeto_item: RigidBody2D) -> void:
	pass
