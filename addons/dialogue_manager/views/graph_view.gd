@tool
extends Control

class_name GraphView

# var main_view: Control
var code_edit: CodeEdit

var current_file: String = "":
	set(new_path):
		print("setting current file: " + new_path)
		current_file = new_path
	get:
		return current_file


func prepare(for_path: String) -> void:
	visible = true
	current_file = for_path

	var parser = DialogueManagerParser.new()
	var errors: Array[Dictionary] = []
	if parser.parse(code_edit.text, for_path) == OK:
		_on_parse_updated(for_path, parser.get_data())
	else:
		print("Initial parse state has errors")

func teardown() -> void:
	super.hide()
	current_file = ""

func _on_parse_updated(for_path: String, parse_result: DialogueManagerParseResult) -> void:
	if !visible or for_path != current_file:
		return

	print(parse_result);
	for title in parse_result.titles.keys():
		print("  - " + title)