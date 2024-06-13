extends Node2D

class_name NPC

@export var dlgPath: String = ''
@export var modColor: Color = Color.WHITE
@export var charScript: DialogueResource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = modColor

func talk() -> bool:
	if charScript != null:
		TranslationServer.set_locale(State.language)
		DialogueManager.show_example_dialogue_balloon(charScript, 'start')
		return true
	return false
