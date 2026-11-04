@tool
class_name CameraGuide
extends FrameworkNode

@export var zoom: float = 1:
	set(value):
		zoom = value
		if _should_draw():
			queue_redraw()

var game_resolution: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_resolution = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)

func _should_draw() -> bool:
	if not is_inside_tree(): # safe-guard for 1st frame, where the node tree isn't initialized yet
		return false
	return get_tree().debug_collisions_hint or Engine.is_editor_hint()

func _draw() -> void:
	if _should_draw():
		var inverse_zoom = 1/zoom
		var zoomed_resolution = game_resolution*inverse_zoom
		var box: Rect2 = Rect2(-zoomed_resolution/2, zoomed_resolution)
		draw_rect(box, Color.CYAN, false, 20.0)
