extends TextureRect

var cargando_agua = false
var cargando_yerba = false
var cantidad_yerba = 0
var cantidad_agua = 0
var mate_rect = get_global_rect()
var mate_completado = false 
signal mate_listo

func _process(_delta: float) -> void:
	var pava_rect = $"../Pava/Pico".get_global_rect()
	var yerba_rect = $"../Yerba/Apertura".get_global_rect()
	cargando_agua = mate_rect.intersects(pava_rect)
	cargando_yerba = mate_rect.intersects(yerba_rect)

func _on_cargar_timeout() -> void:
	if cargando_agua == true:
		if $"../Pava".agua_lista and $"../Pava".cantidad_agua > 2 and $"../Pava".arrastrando  and cantidad_agua < 100 and cantidad_yerba >= 100 :
			cantidad_agua += 5
			$ProgressAgua.value = cantidad_agua
			$"../Pava".cantidad_agua -=2
			
	if cargando_yerba and cantidad_yerba < 100 and $"../Yerba".arrastrando:
		cantidad_yerba+= 5
		$ProgressMate.value = cantidad_yerba

	if  cantidad_agua >= 100 and cantidad_yerba >= 100:
		if not mate_completado:
			mate_completado = true
			emit_signal("mate_listo")
