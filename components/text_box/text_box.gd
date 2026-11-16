@tool
class_name TextBox
extends MarginContainer

@export_multiline() var text: String = "Placeholder":
	set(value):
		text = value
		$RichTextLabel.text = value
