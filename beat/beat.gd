class_name Beat
extends Node

signal finished

@export var camera_position: Marker2D

@export_group("Camera properties")
@export
var duration: float = 2.0
@export
var zoom_out: float = 0.5
@export
var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR


func center_camera() -> void:
	var cam := get_viewport().get_camera_2d()
	var tween := create_tween()
	tween.set_trans(transition_type)
	tween.tween_property(cam, "position", camera_position.position, duration)

	var tween2 := create_tween()
	tween2.set_trans(transition_type)
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(cam, "zoom", Vector2.ONE * zoom_out, duration/2)
	tween2.tween_property(cam, "zoom", Vector2.ONE, duration/2)

func start() -> void:
	center_camera()

func stop() -> void:
	pass
