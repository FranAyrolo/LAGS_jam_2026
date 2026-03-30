extends CharacterBody2D
class_name Player

signal reloj_terminado
enum EstadoPelo {VERDE, AMARILLO, NARANJA, ROJO, NEGRO}

@onready var reloj: TextureProgressBar = %Reloj
@onready var timer_pasos: Timer = $TimerPasos 
@onready var sonido_pasos: AudioStreamPlayer2D = $AudioPasos

@export var estado_pelo: EstadoPelo = EstadoPelo.VERDE
@export var SPEED = 1000.0

var item_en_mano: ObjetoItem
var offset_objeto_mano := Vector2(100, 50)
var offset_detectores: Vector2
var mate_listo: bool = false
var habilitar_input: bool = true
var ubicacion_inicial: Vector2 = Vector2.ZERO

func _ready() -> void:
	Global.cargar_termo.connect(_on_cargar_termo)
	%TimerReloj.timeout.connect(_on_timer_reloj_timeout)
	offset_detectores = %Detectores.position


func _physics_process(_delta: float) -> void:
	if habilitar_input:
		var direction := Vector2(Input.get_axis("INPUT_LEFT", "INPUT_RIGHT"), Input.get_axis("INPUT_UP", "INPUT_DOWN")).normalized()
		velocity = direction * SPEED
		
		_actualizar_animacion(velocity)
		_crecer_pelo()
		move_and_slide()
	
		if velocity.length() > 5.0 and timer_pasos.is_stopped():
			sonido_pasos.play()
			timer_pasos.start()
		if direction.x != 0:
			%Sprite.flip_h = direction.x < 0


func _process(_delta: float) -> void:
	if item_en_mano:
		if %Sprite.flip_h:
			item_en_mano.global_position = global_position + offset_objeto_mano * Vector2(-1, 1)
		else:
			item_en_mano.global_position = global_position + offset_objeto_mano
	
	if %Sprite.flip_h:
		%Detectores.position = offset_detectores * Vector2(-1, 1)
	else:
		%Detectores.position = offset_detectores
	
	if habilitar_input:
		if Input.is_action_just_pressed("INPUT_ITEM"):
			soltar_juntar_item()
		if Input.is_action_pressed("INPUT_INTERACT") && %DetectorDeInteractuables.has_overlapping_bodies():
			for interactuable in %DetectorDeInteractuables.get_overlapping_bodies():
				interactuable.interactuar()


func soltar_juntar_item() -> void:
	if item_en_mano:
		if %DetectorDeInteractuables.has_overlapping_areas():
			var arr = %DetectorDeInteractuables.get_overlapping_areas()
			var depo: DepositoDeObjetos = arr[0]
			var aceptado = depo.recibir_objeto(item_en_mano)
			if aceptado:
				item_en_mano = null
		else:
			soltar_item()
	else:
		if %DetectorDeInteractuables.has_overlapping_areas():
			var arr = %DetectorDeInteractuables.get_overlapping_areas()
			var depo: DepositoDeObjetos = arr[0]
			item_en_mano = depo.soltar_objeto()
			if item_en_mano:
				item_en_mano.reparent(self)
				item_en_mano.ser_juntado()
		else:
			levantar_item()


func soltar_item() -> void:
	item_en_mano.reparent(get_parent())
	item_en_mano.global_position = %DetectorDeItems.global_position
	item_en_mano.ser_puesto_en_el_piso()
	item_en_mano = null


func levantar_item() -> void:
	var bodies: Array[Node2D] = %DetectorDeItems.get_overlapping_bodies()
	var items = bodies.filter(func(b): return b is ObjetoItem)
	if items.size() > 0:
		var objeto = items.pick_random()
		objeto.global_position = global_position
		objeto.reparent(self, false)
		item_en_mano = objeto
		item_en_mano.ser_juntado()


func esta_sosteniendo_item(objeto: String) -> bool:
	if item_en_mano:
		return item_en_mano.item_data.nombre.to_lower() == objeto.to_lower()
	return false


func piden_mate() -> bool:
	if mate_listo:
		%Mate.visible = false
		%BarraMate.value = 0.
		mate_listo = false
		return true
	return false


func recibir_mate() -> void:
	%Mate.visible = true
	%BarraMate.value = 0.


func _on_cargar_termo(cant: float) -> void:
	%BarraTermo.value += cant


func _on_timer_reloj_timeout() -> void:
	if habilitar_input:
		%Reloj.value += %Reloj.step
		if %Reloj.value >= %Reloj.max_value:
			reloj_terminado.emit()


func _actualizar_animacion(velocity_param) -> void:
	var anim = "Verde"
	match estado_pelo:
		EstadoPelo.VERDE: anim = "Verde"
		EstadoPelo.AMARILLO: anim = "Amarillo"
		EstadoPelo.NARANJA: anim = "Naranja"
		EstadoPelo.ROJO: anim = "Rojo"
	
	if velocity_param.length() <= 0.001:
		anim = "Idle" + anim
	else:
		anim = "Move" + anim
	$Sprite.play(anim)


func _crecer_pelo() -> void:
	var target_y = 0
	match estado_pelo:
		EstadoPelo.VERDE: target_y = -700
		EstadoPelo.AMARILLO: target_y = -100
		EstadoPelo.NARANJA: target_y = 100
		EstadoPelo.ROJO: target_y = 250
		EstadoPelo.NEGRO: target_y = 600
	
	$Camera2D/CanvasLayer/Pelo.position.y = lerpf(
		$Camera2D/CanvasLayer/Pelo.position.y,
		target_y,
		0.05
	)


func reiniciar() -> void:
	%Reloj.value = 0.
	habilitar_input = true
	global_position = ubicacion_inicial
	estado_pelo = EstadoPelo.VERDE
