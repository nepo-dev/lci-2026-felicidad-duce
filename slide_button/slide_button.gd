@tool
class_name SlideButton
extends Sprite2D

signal grabbed
signal dropped
signal slide_finished

const DEFAULT_SPRITE_PATH = "res://slide_button/button.svg"

@export_range(0, 1000, 10)
var radius: float = 300:
	set(value):
		radius = value
		if _should_draw():
			queue_redraw()

@onready
var original_position: Vector2 = position
var is_grabbing: bool = false

func _ready() -> void:
	texture = load(DEFAULT_SPRITE_PATH)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			grabbed.emit()
			is_grabbing = true
		else:
			position = original_position
			is_grabbing = false
			dropped.emit()

func _process(_delta: float) -> void:
	if is_grabbing:
		global_position = get_global_mouse_position()
		if _should_draw():
			queue_redraw()
		if (position - original_position).length() >= radius:
			slide_finished.emit()
			process_mode = Node.PROCESS_MODE_DISABLED

func _should_draw() -> bool:
	if is_inside_tree(): # safe-guard for 1st frame, where the node tree isn't initialized yet
		return false
	return get_tree().debug_collisions_hint or Engine.is_editor_hint()

func _draw() -> void:
	if _should_draw():
		draw_circle(original_position-position, radius, Color.AQUA, false, 4)
