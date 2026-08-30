extends Node2D

const SPEED = 60

var direction = 0
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_2d.is_colliding():
		direction = 0
	if ray_cast_2d_2.is_colliding():
		direction = -1
	position.x += direction * SPEED * delta
