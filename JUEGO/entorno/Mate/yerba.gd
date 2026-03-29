extends TextureRect

var arrastrando: bool = false
var offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			arrastrando = true
			offset = get_global_mouse_position() - global_position
			pivot_offset = size / 2
			rotation = -0.5
			z_index = 2
		else:
			arrastrando = false
			rotation = 0
			z_index = 0
	
	if event is InputEventMouseMotion and arrastrando:
		position = get_parent().get_local_mouse_position() - size / 2
