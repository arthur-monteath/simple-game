extends Area2D

const SEED = preload("uid://kj0h38f5mo1o")
@onready var sprite: Sprite2D = %Sprite

var eating := false:
	get: return eating
	set(value):
		var tw := create_tween()
		if value:
			tw.tween_property(sprite, "frame", 2, 0.2)
		else:
			tw.tween_property(sprite, "frame", 0, 0.2)
			tw.tween_callback(spawn_seeds.bind(eaten))
			tw.tween_callback(func(): eaten = 0)
		eating = value

@onready var eating_timer: Timer = %EatingTimer

func _ready():
	eating_timer.timeout.connect(func(): eating = false)

var eaten := 0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("eatable"):
		eating = true
		var body_sprite = body.get_node("Sprite")
		body_sprite.reparent(self)
		body.queue_free()
		var tw := create_tween()
		tw.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(body_sprite, "global_position", global_position, 0.25)
		tw.tween_property(body_sprite, "scale", Vector2.ZERO, 1)
		tw.tween_callback(func():
			body_sprite.queue_free()
			eaten += 1
		)
		eating_timer.start()
		
func spawn_seeds(amount := 1):
	for i in range(0, amount):
		var seed: RigidBody2D = SEED.instantiate()
		seed.global_position = global_position
		seed.linear_velocity = Vector2.UP.rotated((randf()-0.5)*2 * PI/2.0) * 200.0
		seed.get_child(0).global_scale *= 1 + randf()/2.0
		get_parent().add_sibling(seed)
