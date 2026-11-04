@icon("uid://dttkcsq1lvic6")
@tool
class_name Sequence
extends FrameworkNode

signal finished

@export
var current_beat: int = 0
var beat_list: Array = []

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for child in get_children():
		if child is Beat:
			beat_list.append(child)
			child.finished.connect(advance_to_next_beat)
	await get_tree().process_frame
	beat_list[current_beat].call_deferred("start")

func advance_to_next_beat() -> void:
	current_beat += 1
	if current_beat < beat_list.size():
		beat_list[current_beat].start()
	else:
		finished.emit()

func _get_configuration_warnings() -> PackedStringArray:
	for child in get_children():
		if child is Beat:
			return []
	return ["A sequence should have at least 1 child Beat or it will do nothing."]
