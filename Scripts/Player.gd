extends Node2D

class_name Player

@export var move_speed: int = 150

# nodes
var __sensor_shape: CollisionShape2D
var __sensor_poly: CircleShape2D

# player state tracking
var __target_area: Area2D   # what the focus sensor has most recently discovered
var __facing: Vector2       # input direction
var __engaged: bool = false # whether the player is engaged, e.g., whether they should respond to player input

func _ready():
	__sensor_shape = $DialogueCollider/CollisionShape2D
	__sensor_poly = __sensor_shape.shape

	# when we finish a conversation unset engaged
	DialogueManager.dialogue_ended.connect(func(_resource: DialogueResource) -> void: set_engaged(false))

func _draw():
	var sensor_color = Color.RED
	if __target_area != null:
		sensor_color = Color.GREEN
	draw_arc(__sensor_shape.position, __sensor_poly.radius, 0, 2 * PI, 20, sensor_color, 2, true)

func _input(event: InputEvent) -> void:
	if __engaged:
		return

	__facing = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down').normalized()
	if 	event.is_action_pressed('ui_accept') and __target_area != null:
		var npc: NPC = __target_area.get_parent()
		if npc.talk():
			set_engaged(true)

func set_engaged(val: bool) -> void:
	__engaged = val
	if val:
		__facing = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos_delta = __facing * delta * move_speed
	position += pos_delta
	if __facing != Vector2.ZERO:
		rotation = Vector2.UP.angle_to(__facing)
	queue_redraw()

func sensor_exit(area: Area2D):
	if __target_area == area:
		__target_area = null

func sensor_enter(area: Area2D):
	__target_area = area
	print("found with " + area.get_parent().name)