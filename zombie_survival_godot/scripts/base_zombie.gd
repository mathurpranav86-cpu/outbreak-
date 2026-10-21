extends CharacterBody2D

signal killed(zombie_node: Node2D, score: int)

@export var zombie_name: String = "Regular Zombie"
@export var max_health: float = 30.0
@export var speed: float = 110.0
@export var damage: float = 15.0
@export var attack_rate: float = 0.8
@export var score_value: int = 100
@export_range(0.0, 1.0) var knockback_resistance: float = 0.4
@export var blood_splatter_scene: PackedScene

var current_health: float = 30.0
var is_dead: bool = false
var can_attack: bool = true
var knockback_velocity: Vector2 = Vector2.ZERO
var target: Node2D = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
@onready var die_sfx: AudioStreamPlayer2D = $DieSFX
@onready var attack_timer: Timer = $AttackTimer

func _ready() -> void:
	current_health = max_health
	add_to_group("zombies")
	
	if not collision_shape:
		collision_shape = get_node_or_null("CollisionShape2D")
	if not sprite:
		sprite = get_node_or_null("Sprite2D")
	if not hit_sfx:
		hit_sfx = get_node_or_null("HitSFX")
	if not die_sfx:
		die_sfx = get_node_or_null("DieSFX")
	if not attack_timer:
		attack_timer = get_node_or_null("AttackTimer")
	
	if attack_timer:
		attack_timer.one_shot = true
		if not attack_timer.timeout.is_connected(_on_attack_timer_timeout):
			attack_timer.timeout.connect(_on_attack_timer_timeout)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	# Decay knockback
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 700.0 * delta)
	
	if not target or not is_instance_valid(target):
		target = get_tree().get_first_node_in_group("player")
		
	if target and is_instance_valid(target):
		if target.has_method("is_dead") and target.is_dead:
			velocity = knockback_velocity
			move_and_slide()
			return
			
		var to_target = target.global_position - global_position
		var distance = to_target.length()
		var move_dir = to_target.normalized()
		
		# Rotate toward target
		look_at(target.global_position)
		
		velocity = move_dir * speed + knockback_velocity
		move_and_slide()
		
		# Check contact with player for attack
		if distance < 36.0 and can_attack:
			_attack_player(target)
		else:
			for i in range(get_slide_collision_count()):
				var col = get_slide_collision(i)
				var collider = col.get_collider()
				if collider and collider.is_in_group("player") and can_attack:
					_attack_player(collider)
					break
	else:
		velocity = knockback_velocity
		move_and_slide()

func _attack_player(player_node: Node2D) -> void:
	if not can_attack or is_dead:
		return
	can_attack = false
	if attack_timer:
		attack_timer.start(attack_rate)
	if player_node.has_method("take_damage"):
		var dir = (player_node.global_position - global_position).normalized()
		player_node.take_damage(damage, dir)

func _on_attack_timer_timeout() -> void:
	can_attack = true

func take_damage(amount: float, hit_direction: Vector2 = Vector2.ZERO) -> void:
	if is_dead:
		return
		
	current_health -= amount
	
	# Apply knockback
	var knockback_force = 280.0 * (1.0 - knockback_resistance)
	knockback_velocity = hit_direction * knockback_force
	
	# Play hit sound
	if hit_sfx and is_inside_tree():
		hit_sfx.pitch_scale = randf_range(0.9, 1.1)
		hit_sfx.play()
		
	# Spawn blood splatter
	if blood_splatter_scene and get_parent():
		var splatter = blood_splatter_scene.instantiate()
		splatter.global_position = global_position
		get_parent().add_child(splatter)
		
	# Flash red
	if sprite and is_inside_tree():
		var tween = create_tween()
		if tween:
			tween.tween_property(sprite, "modulate", Color(2.5, 0.3, 0.3, 1.0), 0.05)
			tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
		
	if current_health <= 0.0:
		die()

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
		
	emit_signal("killed", self, score_value)
	
	if die_sfx and is_inside_tree():
		die_sfx.pitch_scale = randf_range(0.9, 1.1)
		die_sfx.play()
		
	if sprite and is_inside_tree():
		var tween = create_tween()
		if tween:
			tween.tween_property(sprite, "modulate", Color(0.2, 0.05, 0.05, 0.0), 0.28)
		
	if is_inside_tree() and get_tree():
		var timer = get_tree().create_timer(0.3)
		timer.timeout.connect(queue_free)
	else:
		queue_free()
