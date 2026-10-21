extends Area2D

@export var speed: float = 900.0
@export var damage: float = 25.0
@export var lifetime: float = 1.5

var direction: Vector2 = Vector2.RIGHT
var traveled_time: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	traveled_time += delta
	if traveled_time >= lifetime:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, direction)
		queue_free()
	elif body is StaticBody2D or body is TileMap:
		queue_free()
