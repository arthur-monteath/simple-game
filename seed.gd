extends RigidBody2D

const GROWABLE = preload("uid://dh646mn4hjd10")
@onready var sprite: Sprite2D = %Sprite

func _on_body_entered(_body: Node) -> void:
	plant()
	
@onready var plants: Node2D = %Plants

func plant():
	var growable := GROWABLE.instantiate()
	growable.global_position = global_position
	if plants: plants.add_child(growable)
	else: add_sibling(growable)
	growable.position.y = 0
	var tw := create_tween()
	tw.tween_property(sprite, "self_modulate:a", 0, 1)
	tw.tween_callback(queue_free)
