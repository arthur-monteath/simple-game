extends Area2D

@onready var audio_player: AudioStreamPlayer2D = %AudioPlayer

func _on_body_entered(body: Node2D) -> void:
	audio_player.play()
	get_tree().get_root().get_child(0).add_coin()
	body.queue_free()
