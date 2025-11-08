extends Node2D

@onready var mouse_particles: CPUParticles2D = %SlicingParticles
@onready var sucking_particles: CPUParticles2D = %SuckingParticles
@onready var trail: Line2D = $Trail
@onready var ray: RayCast2D = $RayCast2D
@onready var sucking_area: Area2D = %SuckingArea

func _unhandled_input(_event: InputEvent) -> void:
	mouse_particles.emitting = false
	sucking_particles.emitting = false
	var mouse = get_local_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_particles.position = mouse
		mouse_particles.emitting = true
		trail.add_point(mouse)
		get_tree().create_timer(0.1).timeout.connect(func():trail.remove_point(0))
		_raycast(mouse)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		sucking_particles.position = mouse
		sucking_particles.emitting = true
		sucking_area.position = mouse

func _physics_process(delta: float) -> void:
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): return
	for body in sucking_area.get_overlapping_bodies():
		var orbit_angle: float = ((body.get_instance_id() + Time.get_ticks_msec()) % 500)/500.0
		var orbit_offset = Vector2.from_angle(orbit_angle * 2*PI) * 8
		var target: Vector2 = sucking_area.global_position + orbit_offset
		var direction = target - body.global_position
		if (body as RigidBody2D):
			#body.apply_force(direction * 100.0)
			body.linear_velocity = direction * 25.0
func _raycast(pos: Vector2):
	var size = trail.points.size()
	if size >= 2:
		ray.global_position = trail.global_position + trail.points[size-2]
		ray.target_position = trail.points[size-1] - trail.points[size-2]
		ray.force_raycast_update()
		if ray.is_colliding():
			var area: Area2D = ray.get_collider()
			var growable = area.get_parent()
			if growable.has_method("cut"): growable.cut()

var coin := 0
func add_coin():
	coin += 1
	$CanvasLayer/HBoxContainer/Label.text = str(coin)
