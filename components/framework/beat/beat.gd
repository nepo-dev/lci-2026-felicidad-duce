@tool
@icon("uid://ddayvrd2ueuwn")
class_name Beat
extends FrameworkNode

signal finished
signal user_clicked

## The beat will move to the position and zoom defined by this
## [code]CameraGuide[/code] when it starts. If not specified and a child node of
## type [code]CameraGuide[/code] exists, the child [code]CameraGuide[/code] will
## be used.
@export var camera_guide: CameraGuide
@export var wait_for_click_to_advance: bool = true

@export_group("Camera properties")
@export
var duration: float = 2.0
@export
var zoom_out: float = 0.5
@export
var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR

var _is_camera_moving: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		process_mode = Node.PROCESS_MODE_DISABLED
		if camera_guide == null:
			camera_guide = _get_camera_guide_or_null()
	else:
		if not _get_camera_guide_or_null():
			_add_camera_guide()

func _add_camera_guide():
	if get_children() == []:
		var guide = CameraGuide.new()
		guide.set_name("CameraGuide")
		add_child(guide)
		guide.owner = get_tree().edited_scene_root

func _get_camera_guide_or_null():
	if camera_guide:
		return camera_guide
	for child in get_children():
		if child is CameraGuide:
			return child
	return null

func center_camera() -> void:
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		push_error("Tried to center camera when on camera is visible. Are you trying to center the camera on the first frame?")
		return

	if is_equal_approx(duration, 0):
		return

	_is_camera_moving = true
	var tween := create_tween()
	tween.set_trans(transition_type)
	tween.tween_property(cam, "global_position", camera_guide.global_position, duration)

	var tween2 := create_tween()
	tween2.set_trans(transition_type)
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(cam, "zoom", Vector2.ONE * zoom_out, duration/2)
	tween2.tween_property(cam, "zoom", Vector2.ONE * camera_guide.zoom, duration/2)
	tween2.tween_callback(_on_transition_finished)

func _on_transition_finished() -> void:
	_is_camera_moving = false

func has_transition_finished() -> bool:
	return not _is_camera_moving

## Call this method when the scene starts. It will center the camera and enable
## its components
func start() -> void:
	process_mode = PROCESS_MODE_INHERIT
	center_camera()

## Call this method when the scene finishes. It will move on to the next scene
## and disable its components
func stop() -> void:
	print("%s stopped" % name)
	if wait_for_click_to_advance:
		await user_clicked
		while not has_transition_finished():
			await user_clicked
	finished.emit()
	process_mode = PROCESS_MODE_DISABLED

func _input(event: InputEvent):
	if event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.is_pressed():
		user_clicked.emit()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if not _get_camera_guide_or_null():
		warnings.append("CameraGuide is not set. Please assign one in the Inspector or add a child node of type CameraGuide.")

	return warnings
