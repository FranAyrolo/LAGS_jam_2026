extends BaseCryptid

enum TipoOfrenda {MATE, FUMAR, AZUCAR}

func _ready() -> void:
	activar_criptido()
	
signal jugador_afectado()
signal pombero_enfurecido()

var ofrenda_esperada: TipoOfrenda = TipoOfrenda.MATE
var esperando_ofrenda: bool = false

func estado_cambiado(nuevo_estado: EstadoAlerta) -> void:
	match nuevo_estado:
		EstadoAlerta.VERDE:
			esperando_ofrenda = false
			$PomberitoSprite.play("Idle")
			$Mate.visible = false
			$Puchos.visible = false
			$Azucar.visible = false
		EstadoAlerta.AMARILLO:
			if esperando_ofrenda == false:
				pedir_ofrenda()
		EstadoAlerta.NARANJA:
			if esperando_ofrenda == false:
				pedir_ofrenda()
			emit_signal("jugador_afectado")
		EstadoAlerta.ROJO:
			if esperando_ofrenda == false:
				pedir_ofrenda()
			emit_signal("pombero_enfurecido")


func pedir_ofrenda() -> void:
	ofrenda_esperada = TipoOfrenda.values()[randi() % TipoOfrenda.size()]
	esperando_ofrenda = true
	print("Pombero quiere: ", TipoOfrenda.keys()[ofrenda_esperada])
	actualizar_sprite(ofrenda_esperada)


func recibir_ofrenda(ofrenda: TipoOfrenda) -> void:
	if not esperando_ofrenda:
		return
	if ofrenda == ofrenda_esperada:
		reducir_contador(20)
		revisar_puntaje()
		if estado_alerta_actual != EstadoAlerta.VERDE:
			pedir_ofrenda()
	else:
		incrementar_contador(10)
		revisar_puntaje()


func actualizar_sprite(ofrenda: TipoOfrenda) -> void:
	$Mate.visible = ofrenda == TipoOfrenda.MATE
	$Puchos.visible = ofrenda == TipoOfrenda.FUMAR
	$Azucar.visible = ofrenda == TipoOfrenda.AZUCAR
	match ofrenda:
		TipoOfrenda.MATE:   
			$PomberitoSprite.play("Mate")
		TipoOfrenda.FUMAR:  
			$PomberitoSprite.play("Fumar")
		TipoOfrenda.AZUCAR: 
			$PomberitoSprite.play("Azucar")


func _on_deposito_pomberito_objeto_aceptado(tipo: String) -> void:
	match tipo:
		"mate":   recibir_ofrenda(TipoOfrenda.MATE)
		"cigarrillos":  recibir_ofrenda(TipoOfrenda.FUMAR)
		"azucar": recibir_ofrenda(TipoOfrenda.AZUCAR)
