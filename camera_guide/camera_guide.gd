@tool
class_name CameraGuide
extends Node2D

@export var zoom: float = 1:
	set(value):
		zoom = value
		queue_redraw()

var game_resolution: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_resolution = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	var inverse_zoom = 1/zoom
	var zoomed_resolution = game_resolution*inverse_zoom
	var box: Rect2 = Rect2(-zoomed_resolution/2, zoomed_resolution)
	draw_rect(box, Color.CYAN, false, 20.0)
