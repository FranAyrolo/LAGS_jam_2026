extends TextureRect


var prendida: bool = false
var arrastrando: bool = false
var offset: Vector2 = Vector2.ZERO
var temp_progreso: float = 80.0
var cantidad_agua: float = 100.0
var agua_lista = false

var sobre_canilla: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

func _process(delta: float) -> void:
	var pava_rect = $Pico.get_global_rect()
	var canilla_rect = $"../Bacha/ZonaValida".get_global_rect()
	sobre_canilla = pava_rect.intersects(canilla_rect)
	print(rotation)
		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastrando = true
			offset = get_global_mouse_position() - global_position
			pivot_offset = size / 2
			rotation = -0.5
			z_index= 2
		else:
			arrastrando = false
			rotation = 0
			z_index= 0
	
	if event is InputEventMouseMotion and arrastrando:
		position = get_parent().get_local_mouse_position() - size / 2

func _on_boton_toggled(pressed: bool) -> void:
	prendida = pressed

func _on_timer_timeout() -> void:
	if not arrastrando and cantidad_agua >= 50:
		if prendida:
			if temp_progreso < 100:
				temp_progreso +=1
		else:
			if temp_progreso > 20:
				temp_progreso -=0.25
		$Temp.text = str(int(temp_progreso))
	if temp_progreso < 80:
		agua_lista = false
		$Temp.add_theme_color_override("font_color", Color.BLUE)
	elif temp_progreso < 90:
		agua_lista = true	
		$Temp.add_theme_color_override("font_color", Color.GREEN)
	else:
		agua_lista = false
		$Temp.add_theme_color_override("font_color", Color.RED)
			
func _on_check_button_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
	if $CheckButton.button_pressed == true:
		prendida = true
	else:
		prendida = false

func _on_cargar_timeout() -> void:
	if cantidad_agua <100:
		if sobre_canilla:
			cantidad_agua +=5
	if cantidad_agua > 30:
		$CheckButton.disabled = false
	else:
		$CheckButton.disabled = true
		prendida = false
	$CargaAgua.value = cantidad_agua
	
	
	
	
