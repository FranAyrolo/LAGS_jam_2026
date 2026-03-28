extends CharacterBody2D
class_name Player

@onready var reloj: TextureProgressBar = %Reloj

@export var SPEED = 1000.0
var item_en_mano: ObjetoItem
var offset_objeto_mano := Vector2(100, 50)
var offset_detectores: Vector2
var mate_listo: bool = false

func _ready() -> void:
	#Global.item_seleccionado.connect(_on_item_seleccionado)
	Global.cargar_termo.connect(_on_cargar_termo)
	%TimerReloj.timeout.connect(_on_timer_reloj_timeout)
	offset_detectores = %Detectores.position


func _physics_process(_delta: float) -> void:
<<<<<<< HEAD
	var direction := Vector2(Input.get_axis("INPUT_LEFT", "INPUT_RIGHT"), Input.get_axis("INPUT_UP", "INPUT_DOWN"))
	velocity = direction.normalized() * SPEED
=======
	var direction := Vector2(Input.get_axis("INPUT_LEFT", "INPUT_RIGHT"), Input.get_axis("INPUT_UP", "INPUT_DOWN")).normalized()
	velocity = direction * SPEED
>>>>>>> main
	if velocity.distance_to(Vector2.ZERO) <= 0.001:
		$Sprite.play("Idle")
	else:
		$Sprite.play("Movimiento")
<<<<<<< HEAD
	#velocity.move_toward(Vector2.ZERO, SPEED)
=======
		move_and_slide()
	velocity.move_toward(Vector2.ZERO, SPEED)
>>>>>>> main
	
	#Alinear el sprite y el objeto en la mano
	if direction.x != 0:
		%Sprite.flip_h = direction.x < 0


func _process(_delta: float) -> void:
	#gestion de sprites e items
	if item_en_mano:
		if %Sprite.flip_h:
			item_en_mano.global_position = global_position + offset_objeto_mano * Vector2(-1, 1)
		else:
			item_en_mano.global_position = global_position + offset_objeto_mano
	
	if %Sprite.flip_h:
		%Detectores.position = offset_detectores * Vector2(-1, 1)
	else:
		%Detectores.position = offset_detectores
	
	if Input.is_action_just_pressed("INPUT_ITEM"):
		soltar_juntar_item()
	if Input.is_action_pressed("INPUT_INTERACT") && %DetectorDeInteractuables.has_overlapping_bodies():
		for interactuable in %DetectorDeInteractuables.get_overlapping_bodies():
			interactuable.interactuar()
	
	#Carga del mate
	if %Mate.button_pressed && !mate_listo && %BarraTermo.value > 0.:
		%BarraMate.value += %BarraMate.step
		%BarraTermo.value -= %BarraMate.step
	mate_listo = %BarraMate.value >= %BarraMate.max_value


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


func piden_mate() -> bool:
	if mate_listo:
		%Mate.visible = false
		%BarraMate.value = 0.
		mate_listo = false
		return true
	else:
		return false


func recibir_mate() -> void:
	%Mate.visible = true
	%BarraMate.value = 0.


func _on_cargar_termo(cant: float) -> void:
	%BarraTermo.value += cant


func _on_item_seleccionado(_item: ItemResource, objeto_item: RigidBody2D) -> void:
	pass


func _on_timer_reloj_timeout() -> void:
	%Reloj.value += %Reloj.step
	if %Reloj.value >= %Reloj.max_value:
		Global.reloj_jugador_termino.emit()
