extends Beat


func _ready() -> void:
	super()
	finished.emit()
