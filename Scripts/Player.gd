extends Node2D

@export var velocity: int = 150

# nodes
var __sensor_shape: CollisionShape2D
var __sensor_poly: CircleShape2D

# focus_target
var __target_area: Area2D

func _ready():
	__sensor_shape = $DialogueCollider/CollisionShape2D
	__sensor_poly = __sensor_shape.shape

func _draw():
	var sensor_color = Color.RED
	if __target_area != null:
		sensor_color = Color.GREEN
	draw_arc(__sensor_shape.position, __sensor_poly.radius, 0, 2 * PI, 20, sensor_color, 2, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_vector = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')
	var vector_normalized = input_vector.normalized()
	var pos_delta = vector_normalized * delta * velocity

	position += pos_delta
	if vector_normalized != Vector2.ZERO:
		rotation = Vector2.UP.angle_to(vector_normalized)
	queue_redraw()

	if Input.is_action_just_pressed('ui_accept') and __target_area != null:
		var npc: NPC = __target_area.get_parent()
		npc.talk()


func sensor_exit(area: Area2D):
	if __target_area == area:
		__target_area = null

func sensor_enter(area: Area2D):
	__target_area = area
	print("collision with " + area.get_parent().name)