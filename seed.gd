extends RigidBody2D

const GROWABLE = preload("uid://dh646mn4hjd10")
@onready var sprite: Sprite2D = %Sprite

func _on_body_entered(_body: Node) -> void:
	plant()

func plant():
	set_deferred("freeze", true)
	var growable := GROWABLE.instantiate()
	growable.global_position = global_position
	if get_tree().root.get_node("%Plant"): get_tree().root.get_node("%Plant").add_child(growable)
	else: add_sibling(growable)
	growable.set_deferred("position:y", 0)
	var tw := create_tween()
	tw.tween_property(sprite, "self_modulate:a", 0, 1)
	tw.tween_callback(queue_free)
