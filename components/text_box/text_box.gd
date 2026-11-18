@tool
class_name TextBox
extends MarginContainer

signal finished

const CHARACTERS_PER_SECOND: float = 50

@onready var text_label: RichTextLabel = $RichTextLabel
@export_multiline() var text: String = "Placeholder":
	set(value):
		text = value
		if not is_node_ready():
			await ready
		text_label.text = value
		_animate_text()

func _animate_text() -> void:
	var tween := create_tween()
	text_label.visible_ratio = 0

	var duration = text_label.get_parsed_text().length() / CHARACTERS_PER_SECOND

	tween.tween_property($RichTextLabel, "visible_ratio", 1, duration)
	tween.tween_callback(finished.emit)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
