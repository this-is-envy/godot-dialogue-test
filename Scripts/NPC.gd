extends Node2D

class_name NPC

@export var dlgPath: String = ''
@export var modColor: Color = Color.WHITE
@export var charScript: DialogueResource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = modColor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func talk() -> void:
	if charScript != null:
		DialogueManager.show_example_dialogue_balloon(charScript, 'start')