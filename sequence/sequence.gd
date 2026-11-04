extends Node2D

signal finished

@export
var current_beat: int = 0
var beat_list: Array = []

func _ready() -> void:
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
