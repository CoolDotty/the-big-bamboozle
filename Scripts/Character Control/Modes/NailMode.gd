extends Node2D

var mode_active = false

const NAIL = preload("res://assets/Nodes/Player Nodes/nail_projectile.tscn")

@export var projectile_speed := 600.0
@export var fire_rate := 0.4

var can_shoot = true

var scene_root

func _ready():
	scene_root = get_tree().get_root().get_node("Scene Root") 

func disable_mode():
	mode_active = false
	self.visible = false

func enable_mode():
	mode_active = true
	self.visible = true

func _process(delta):
	if not mode_active:
		return 

	#update graphic position
	self.global_position = get_parent().global_position
	self.global_rotation = get_parent().global_rotation
	
	#shoot nail
	if Input.is_action_pressed("input_fire") and can_shoot:
		if get_parent().get_collider():
			if get_parent().get_collider().is_in_group("Person"):
				return

		var n = NAIL.instantiate()
		n.projectile_speed = projectile_speed
		scene_root.add_child(n)
		n.global_transform = $Marker2D.global_transform
		n.look_at(get_global_mouse_position())
		can_shoot = false
		$Timer.start(fire_rate)

	queue_redraw()

func _draw():
	#I don't like this solution of redrawing every frame just to clear
	#But I'm not sure how to clear everything in _draw, so instead we just draw an "empty" image when not needed
	if get_parent().get_collider():
		if get_parent().get_collider().is_in_group("Person"):
			draw_circle(get_parent().hit_point, 10, Color(255, 0, 0))
			return

	#ugly way of just removing the drawn vector if no previous conditions are met
	draw_circle(Vector2(), 0, Color(0, 0, 0))

func _on_timer_timeout():
	can_shoot = true
