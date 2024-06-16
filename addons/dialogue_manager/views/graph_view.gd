@tool
extends Control

class_name GraphView

const DialogueConstants = preload("../constants.gd")

@onready var display_grid: GraphEdit = %DisplayGrid

# var main_view: Control
var code_edit: CodeEdit

var current_file: String = "":
	set(new_path):
		if (current_file != new_path):
			for c in display_grid.get_children():
				display_grid.remove_child(c)
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

	var nodes = []

	# sort the keys by line number
	var line_keys = parse_result.lines.keys()
	line_keys.sort_custom(func(a, b) -> bool: return int(a) < int(b))

	var working_node: DialogueNode = null

	for line_no in line_keys:
		var line = parse_result.lines[line_no]
		if line['type'] == DialogueConstants.TYPE_TITLE:
			if working_node != null:
				nodes.append(working_node)
				working_node = null
			working_node = DialogueNode.mk_node(line)

		if working_node != null:
			working_node.add_line(line)
		else:
			print('Found non-title line without block context: ' + line)

	if working_node != null:
		print('Appending node')
		nodes.append(working_node)
		working_node = null

	print("defined nodes:")
	for c in display_grid.get_children():
		display_grid.remove_child(c)

	for n in nodes:
		var gn = GraphNode.new()
		gn.title = str(n.id) + ": " + n.title
		display_grid.add_child(gn)