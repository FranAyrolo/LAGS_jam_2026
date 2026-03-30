extends CharacterBody2D
class_name Player

@onready var reloj: TextureProgressBar = %Reloj

# --- NODOS DE AUDIO Y CONTROL DE PASOS ---
# Asegúrate de que el Timer en el árbol se llame "TimerPasos" (o usa el nombre único %)
@onready var step_timer: Timer = $TimerPasos 
@onready var step_sound: AudioStreamPlayer2D = $AudioPasos
# ------------------------------------------

@export var SPEED = 1000.0
var item_en_mano: ObjetoItem
var offset_objeto_mano := Vector2(100, 50)
var offset_detectores: Vector2
var mate_listo: bool = false
enum EstadoPelo {VERDE, AMARILLO, NARANJA, ROJO, NEGRO}
@export var estado_actual: EstadoPelo = EstadoPelo.VERDE
var habilitar_input: bool = true

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
		
		# --- LÓGICA DE PASOS ---
		if velocity.length() > 5.0 and step_timer.is_stopped():
			_reproducir_paso()
			step_timer.start()
		# -----------------------
		
		if direction.x != 0:
			%Sprite.flip_h = direction.x < 0

func _reproducir_paso() -> void:
	# Como ya configuraste el Randomizer en el Inspector, 
	# solo hace falta darle a play() y Godot elige el sonido solo.
	step_sound.play()

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
		
		if %Mate.button_pressed && !mate_listo && %BarraTermo.value > 0.:
			%BarraMate.value += %BarraMate.step
			%BarraTermo.value -= %BarraMate.step
		mate_listo = %BarraMate.value >= %BarraMate.max_value

# --- FUNCIONES DE ITEMS ---

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

# --- SISTEMA DE MATE Y RELOJ ---

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
	%Reloj.value += %Reloj.step
	if %Reloj.value >= %Reloj.max_value:
		Global.reloj_jugador_termino.emit()

# --- ESTÉTICA Y ANIMACIÓN ---

func _actualizar_animacion(velocity_param) -> void:
	var anim = "Verde"
	match estado_actual:
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
	match estado_actual:
		EstadoPelo.VERDE: target_y = -700
		EstadoPelo.AMARILLO: target_y = -100
		EstadoPelo.NARANJA: target_y = 100
		EstadoPelo.ROJO: target_y = 300
		EstadoPelo.NEGRO: target_y = 600
	
	$Camera2D/CanvasLayer/Pelo.position.y = lerpf(
		$Camera2D/CanvasLayer/Pelo.position.y,
		target_y,
		0.05
	)
