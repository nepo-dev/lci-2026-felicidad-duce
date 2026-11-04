@tool
extends MarginContainer

@export var text: String = "Placeholder":
	set(value):
		text = value
		$Label.text = value
		_fit_text()

## Smallest allowed font size (prevents shrinking text until unreadable)
var _min_font_size: int = 6

## Largest allowed font size
var _max_font_size: int = 200

## Step size used when searching for a fitting font size
var _step_size: int = 1

##
var _margin: float = 80 #px

## If true, re-fit the text whenever the container is resized in the editor.
@export var auto_fit_on_resize: bool = true

func _ready() -> void:
	if Engine.is_editor_hint():
		_fit_text()
		resized.connect(_fit_text)

func _notification(what: int) -> void:
	if not Engine.is_editor_hint():
		return
	if what == NOTIFICATION_RESIZED and auto_fit_on_resize:
		_fit_text()

func _fit_text() -> void:
	var target_label: Label = $Label

	var available_width := size.x - get_theme_constant("margin_left") - get_theme_constant("margin_right") - _margin
	if available_width <= 0:
		return

	var font := target_label.get_theme_font("font")

	_grow_until_fit(target_label, font, available_width)

func _grow_until_fit(target_label: Label, font: Font, available_width: float):
	# Grow until find the largest size that still fits.
	var best_size := _min_font_size
	var current_size := _min_font_size
	while current_size <= _max_font_size:
		var text_width := font.get_string_size(
			target_label.text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			current_size
		).x
		if text_width <= available_width:
			best_size = current_size
			current_size += _step_size
		else:
			break

	target_label.add_theme_font_size_override("font_size", best_size)
