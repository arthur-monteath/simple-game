class_name Tentacle extends Node2D

const ITERATIONS := 100
const separation := 2
const points := 32

@onready var line: Line2D = %Line2D

func _ready() -> void:
	line.clear_points()
	for i in points:
		line.add_point(Vector2(i*separation, 0))

func set_target(pos: Vector2):
	var size = line.get_point_count()
	for _iter in range(ITERATIONS):
		# forward pass
		line.set_point_position(size-1, pos)
		for i in range(size-2, -1, -1):
			var dir = line.points[i+1] - line.points[i]
			var point = line.points[i+1] - dir.normalized() * separation
			line.set_point_position(i, point)
		# backward pass
		line.set_point_position(0, Vector2.ZERO)
		for i in range(1, size):
			var dir = line.points[i-1] - line.points[i]
			var point = line.points[i-1] - dir.normalized() * separation
			line.set_point_position(i, point)

func _process(_delta: float) -> void:
	var mouse = get_local_mouse_position() + Vector2.from_angle(randf()*2*PI) * randf() * 32.0
	set_target(mouse)
