extends CharacterBody2D

@export var SPEED = 100000.0


func _physics_process(delta: float) -> void:
	var direction := Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	velocity = direction * SPEED * delta
	#if velocity.x == 0.:
	velocity.move_toward(Vector2.ZERO, SPEED)
	%Sprite.flip_h = direction.x > 0
	
	move_and_slide()
