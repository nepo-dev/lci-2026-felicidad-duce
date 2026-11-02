@tool
class_name Beat
extends Node

signal finished

## The beat will move to the position and zoom defined by this
## [code]CameraGuide[/code] when it starts. If not specified and a child node of
## type [code]CameraGuide[/code] exists, the child [code]CameraGuide[/code] will
## be used.
@export var camera_guide: CameraGuide

@export_group("Camera properties")
@export
var duration: float = 2.0
@export
var zoom_out: float = 0.5
@export
var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR

func _ready() -> void:
	if camera_guide == null:
		if not Engine.is_editor_hint():
			camera_guide = _get_camera_guide_or_null()

func _get_camera_guide_or_null():
	if camera_guide:
		return camera_guide
	for child in get_children():
		if child is CameraGuide:
			return child
	return null

func center_camera() -> void:
	var cam := get_viewport().get_camera_2d()
	var tween := create_tween()
	tween.set_trans(transition_type)
	tween.tween_property(cam, "global_position", camera_guide.global_position, duration)

	var tween2 := create_tween()
	tween2.set_trans(transition_type)
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(cam, "zoom", Vector2.ONE * zoom_out, duration/2)
	tween2.tween_property(cam, "zoom", Vector2.ONE * camera_guide.zoom, duration/2)

func start() -> void:
	center_camera()

func stop() -> void:
	pass

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if not _get_camera_guide_or_null():
		warnings.append("CameraGuide is not set. Please assign one in the Inspector or add a child node of type CameraGuide.")

	return warnings
