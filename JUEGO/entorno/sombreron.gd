extends BaseCryptid

func _ready() -> void:
	activar_criptido()
	
signal jugador_afectado()
signal sombreron_enfurecido()

var esperando_pelo: bool = false

func estado_cambiado(nuevo_estado: EstadoAlerta) -> void:
	match nuevo_estado:
		EstadoAlerta.VERDE:
			esperando_pelo = false
		EstadoAlerta.AMARILLO:
			esperando_pelo = true
			%Player.estado_actual = %Player.EstadoPelo.AMARILLO
		EstadoAlerta.NARANJA:
			%Player.estado_actual = %Player.EstadoPelo.NARANJA
		EstadoAlerta.ROJO:
			%Player.estado_actual = %Player.EstadoPelo.ROJO

func _on_deposito_sombreron_objeto_aceptado(tipo: String) -> void:
		reiniciar_alerta()
		revisar_puntaje()
		$"../../Objetos/DepositoSombreron".consumir_objeto()
