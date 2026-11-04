class_name Layer
extends FrameworkNode

@export var visible_at_start: bool = true
@export var transition_time: float = 1

@onready var original_color: Color = modulate

func _ready() -> void:
	if not visible_at_start:
		modulate = Color.TRANSPARENT

func show_layer() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", original_color, transition_time)

func hide_layer() -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, transition_time)
