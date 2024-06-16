@tool
class_name DialogueNode extends RefCounted

# what line is this on
var id: int = -1

# what line does this block start on
var start_id: int = -1

# what this node is called
var title: String = ""

# array of lines that compose this node
var lines = []

# outbound links
var outbound = {}


static func mk_node(line) -> DialogueNode:
  var dn = DialogueNode.new()
  dn.id = line['id']
  dn.start_id = line['next_id']
  dn.title = line['text']
  return dn

func add_line(line_obj) -> void:
  lines.append(line_obj)

func _to_string() -> String:
  var line_str = ""

  if lines.size() == 0:
    line_str = "n/a"
  else:
    line_str = str(lines[0]['id'])
    for idx in range(1, lines.size()):
      line_str += ", " + str(lines[idx]['id'])

  return str(id) + ": " + title + "[" + line_str + "]"