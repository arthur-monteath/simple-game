class_name Tentacle extends Node2D

const ITERATIONS := 100
const separation := 2
const points := 32
const wave_offset := 2
const wave_length: float = 4
const wave_speed := 2

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
	
	apply_wave(pos)

func _process(_delta: float) -> void:
	var noise = Vector2.from_angle(randf()*2*PI) * randf() * 32.0
	var mouse = get_local_mouse_position()
	set_target(mouse)

func apply_wave(pos):
	var size = line.get_point_count()
	var time = Time.get_ticks_msec()/1000.0 * wave_speed
	line.set_point_position(size-1, pos)
	for i in range(size-2, -1, -1):
		var dir = line.points[i+1] - line.points[i]
		var point = line.points[i+1] - dir.normalized() * separation
		var offset = Vector2(-dir.y, dir.x).normalized() * sin(i/wave_length + time) * wave_offset
		point += offset
		line.set_point_position(i, point)
	# backward pass
	line.set_point_position(0, Vector2.ZERO)
	for i in range(1, size):
		var dir = line.points[i-1] - line.points[i]
		var point = line.points[i-1] - dir.normalized() * separation
		var offset = Vector2(-dir.y, dir.x).normalized() * sin(i/wave_length + time) * wave_offset
		point += offset
		line.set_point_position(i, point)
