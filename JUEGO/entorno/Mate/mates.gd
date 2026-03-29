extends Control

signal mate_listo

func _ready() -> void:
	visible = false

func _on_mate_mate_listo() -> void:
	emit_signal("mate_listo") 

func resetear() -> void:
	$"Cargar Agua/Mate".cantidad_agua = 0
	$"Cargar Agua/Mate".cantidad_yerba = 0
	$"Cargar Agua/Mate".mate_completado = false
	$"Cargar Agua/Mate/ProgressMate".value =0
	$"Cargar Agua/Mate/ProgressAgua".value =0
