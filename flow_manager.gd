extends Node

@export
var beat_list: Array[Beat]

@export
var beat_index: int = 0

func _ready() -> void:
	for child in get_children():
		if child is Beat:
			beat_list.append(child)
			child.finished.connect(move_to_next_beat)
	beat_list[beat_index].start()

func move_to_next_beat():
	beat_list[beat_index].stop()
	beat_index += 1
	beat_list[beat_index].start()

func reset():
	$Camera2D.position = Vector2(576.0, 324.0)
	$Beat2.center_camera()
	
