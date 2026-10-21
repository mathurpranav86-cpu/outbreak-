class_name Weapon
extends Node2D

signal ammo_changed(current: int, max_mag: int)
signal reload_started(duration: float)
signal reload_finished()
signal weapon_fired()

@export var weapon_name: String = "Pistol"
@export var damage: float = 25.0
@export var fire_rate: float = 0.22  # Seconds between shots
@export var mag_capacity: int = 12
@export var reload_time: float = 1.2
@export var bullet_speed: float = 900.0
@export var bullet_spread_deg: float = 2.5
@export var is_automatic: bool = false

var current_ammo: int = 12
var can_fire: bool = true
var is_reloading: bool = false

var fire_timer: Timer
var reload_timer: Timer

func _init() -> void:
	fire_timer = Timer.new()
	fire_timer.one_shot = true
	reload_timer = Timer.new()
	reload_timer.one_shot = true

func _ready() -> void:
	current_ammo = mag_capacity
	
	if not fire_timer.timeout.is_connected(_on_fire_timer_timeout):
		fire_timer.timeout.connect(_on_fire_timer_timeout)
	if not fire_timer.is_inside_tree():
		add_child(fire_timer)
		
	if not reload_timer.timeout.is_connected(_on_reload_timer_timeout):
		reload_timer.timeout.connect(_on_reload_timer_timeout)
	if not reload_timer.is_inside_tree():
		add_child(reload_timer)
		
	emit_signal("ammo_changed", current_ammo, mag_capacity)

func try_shoot(muzzle_global_pos: Vector2, target_global_pos: Vector2, bullet_scene: PackedScene, bullet_container: Node) -> bool:
	if is_reloading or not can_fire:
		return false
		
	if current_ammo <= 0:
		start_reload()
		return false
		
	# Consume ammo
	current_ammo -= 1
	can_fire = false
	if fire_timer:
		if not fire_timer.is_inside_tree():
			add_child(fire_timer)
		fire_timer.start(fire_rate)
		
	emit_signal("ammo_changed", current_ammo, mag_capacity)
	emit_signal("weapon_fired")
	
	# Spawn bullet
	if bullet_scene and bullet_container:
		var bullet = bullet_scene.instantiate()
		var base_direction = (target_global_pos - muzzle_global_pos).normalized()
		if base_direction == Vector2.ZERO:
			base_direction = Vector2.RIGHT
			
		# Apply slight spread
		var spread_rad = deg_to_rad(randf_range(-bullet_spread_deg, bullet_spread_deg))
		var shot_direction = base_direction.rotated(spread_rad)
		
		bullet.global_position = muzzle_global_pos
		bullet.direction = shot_direction
		bullet.speed = bullet_speed
		bullet.damage = damage
		bullet.rotation = shot_direction.angle()
		
		bullet_container.add_child(bullet)
		
	# Auto-reload when empty
	if current_ammo == 0:
		start_reload()
		
	return true

func start_reload() -> void:
	if is_reloading or current_ammo == mag_capacity:
		return
	is_reloading = true
	if reload_timer:
		if not reload_timer.is_inside_tree():
			add_child(reload_timer)
		reload_timer.start(reload_time)
	emit_signal("reload_started", reload_time)

func _on_fire_timer_timeout() -> void:
	can_fire = true

func _on_reload_timer_timeout() -> void:
	is_reloading = false
	current_ammo = mag_capacity
	emit_signal("ammo_changed", current_ammo, mag_capacity)
	emit_signal("reload_finished")
