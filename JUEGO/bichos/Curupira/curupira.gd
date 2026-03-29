extends BaseCryptid
class_name Curupira


@onready var macetas: ControlMacetas = $Macetas

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	estado_score_track = macetas.estado_general
	revisar_puntaje()
