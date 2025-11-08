class_name Growable extends Node2D

const BIT = preload("uid://b204702xw015e")

@onready var sprite: Sprite2D = %Sprite
@onready var growth_timer: Timer = %GrowthTimer

@export var growth_time: float:
	set(value):
		growth_time = value
		if growth_timer: growth_timer.wait_time = value

@export var growth := 0.0

func _ready():
	growth_timer.wait_time = growth_time
	growth_timer.timeout.connect(grow)
	growth_timer.start()
	
func grow():
	growth += 1.0 / sprite.hframes
	sprite.frame += 1
	if growth >= 1:
		growth = 1
		sprite.frame = sprite.hframes - 1
		growth_timer.stop()
		return

func cut():
	spawn_bits(int(growth * sprite.hframes))
	queue_free()

func spawn_bits(amount := 1):
	for i in range(0, amount):
		var bit: RigidBody2D = BIT.instantiate()
		bit.global_position = global_position
		bit.linear_velocity = Vector2.UP.rotated((randf()-0.5)*2 * PI/4.0) * 75.0
		bit.get_child(0).global_scale *= 1 + randf()/2.0
		add_sibling(bit)
