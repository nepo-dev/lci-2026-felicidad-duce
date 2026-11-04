@tool
class_name TextBox
extends MarginContainer

@export var text: String = "Placeholder":
	set(value):
		text = value
		$Label.text = value
