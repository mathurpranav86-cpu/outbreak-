extends CharacterBody2D

signal health_changed(current: float, max_hp: float)
signal died()
signal ammo_changed(current: int, max_mag: int)
signal reloading_status(is_reloading: bool)

@export var speed: float = 230.0
@export var max_health: float = 100.0
@export var bullet_scene: PackedScene

var current_health: float = 100.0
var is_dead: bool = false
var bullet_container: Node = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Muzzle
@onready var muzzle_flash: Sprite2D = $Muzzle/MuzzleFlash
@onready var weapon: Weapon = $Weapon
@onready var shoot_sfx: AudioStreamPlayer2D = $ShootSFX
@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX
@onready var reload_sfx: AudioStreamPlayer2D = $ReloadSFX

func _ready() -> void:
	_ensure_input_actions()
	current_health = max_health
	add_to_group("player")
	
	if not weapon:
		weapon = get_node_or_null("Weapon")
	if not muzzle:
		muzzle = get_node_or_null("Muzzle")
	if not muzzle_flash and muzzle:
		muzzle_flash = muzzle.get_node_or_null("MuzzleFlash")
	if not sprite:
		sprite = get_node_or_null("Sprite2D")
	if not shoot_sfx:
		shoot_sfx = get_node_or_null("ShootSFX")
	if not hurt_sfx:
		hurt_sfx = get_node_or_null("HurtSFX")
	if not reload_sfx:
		reload_sfx = get_node_or_null("ReloadSFX")
	
	if muzzle_flash:
		muzzle_flash.visible = false
		
	# Connect weapon signals
	if weapon:
		if not weapon.ammo_changed.is_connected(_on_weapon_ammo_changed):
			weapon.ammo_changed.connect(_on_weapon_ammo_changed)
		if not weapon.reload_started.is_connected(_on_weapon_reload_started):
			weapon.reload_started.connect(_on_weapon_reload_started)
		if not weapon.reload_finished.is_connected(_on_weapon_reload_finished):
			weapon.reload_finished.connect(_on_weapon_reload_finished)
		if not weapon.weapon_fired.is_connected(_on_weapon_fired):
			weapon.weapon_fired.connect(_on_weapon_fired)
		emit_signal("ammo_changed", weapon.current_ammo, weapon.mag_capacity)
		
	emit_signal("health_changed", current_health, max_health)

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
		
	# 1. Aim toward mouse cursor
	look_at(get_global_mouse_position())
	
	# 2. Movement handling (WASD & Arrow keys)
	var move_vec = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1.0
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1.0
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1.0
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1.0
		
	move_vec = move_vec.normalized()
	velocity = move_vec * speed
	move_and_slide()
	
	# 3. Shooting handling
	if Input.is_action_pressed("shoot"):
		_trigger_shoot()
		
	# 4. Manual reload
	if Input.is_action_just_pressed("reload") and weapon:
		weapon.start_reload()

func _trigger_shoot() -> void:
	if not weapon:
		return
	if not bullet_container:
		bullet_container = get_parent()
		
	var target = get_global_mouse_position()
	var muzzle_pos = global_position
	if muzzle:
		muzzle_pos = muzzle.global_position
	weapon.try_shoot(muzzle_pos, target, bullet_scene, bullet_container)

func _on_weapon_fired() -> void:
	if shoot_sfx and is_inside_tree():
		shoot_sfx.pitch_scale = randf_range(0.95, 1.05)
		shoot_sfx.play()
	_show_muzzle_flash()

func _show_muzzle_flash() -> void:
	if not muzzle_flash:
		return
	muzzle_flash.visible = true
	if is_inside_tree() and get_tree():
		var timer = get_tree().create_timer(0.04)
		timer.timeout.connect(func(): muzzle_flash.visible = false)
	else:
		muzzle_flash.visible = false

func _on_weapon_ammo_changed(cur: int, max_mag: int) -> void:
	emit_signal("ammo_changed", cur, max_mag)

func _on_weapon_reload_started(_duration: float) -> void:
	emit_signal("reloading_status", true)
	if reload_sfx and is_inside_tree():
		reload_sfx.play()

func _on_weapon_reload_finished() -> void:
	emit_signal("reloading_status", false)

func take_damage(amount: float, _knockback_dir: Vector2 = Vector2.ZERO) -> void:
	if is_dead:
		return
		
	current_health = max(0.0, current_health - amount)
	emit_signal("health_changed", current_health, max_health)
	
	if hurt_sfx and is_inside_tree():
		hurt_sfx.pitch_scale = randf_range(0.9, 1.1)
		hurt_sfx.play()
		
	# Red damage flash tween
	if sprite and is_inside_tree():
		var tween = create_tween()
		if tween:
			tween.tween_property(sprite, "modulate", Color(2.5, 0.4, 0.4, 1.0), 0.06)
			tween.tween_property(sprite, "modulate", Color.WHITE, 0.12)
		
	if current_health <= 0.0:
		die()

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	emit_signal("died")
	
	# Death visual feedback
	if sprite and is_inside_tree():
		var tween = create_tween()
		if tween:
			tween.tween_property(sprite, "modulate", Color(0.3, 0.1, 0.1, 0.6), 0.4)

func _ensure_input_actions() -> void:
	var mappings = {
		"move_left": [KEY_A, KEY_LEFT],
		"move_right": [KEY_D, KEY_RIGHT],
		"move_up": [KEY_W, KEY_UP],
		"move_down": [KEY_S, KEY_DOWN],
		"reload": [KEY_R],
		"pause": [KEY_ESCAPE, KEY_P]
	}
	for action in mappings:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			for keycode in mappings[action]:
				var ev = InputEventKey.new()
				ev.physical_keycode = keycode
				InputMap.action_add_event(action, ev)
				
	if not InputMap.has_action("shoot"):
		InputMap.add_action("shoot")
		var ev_mouse = InputEventMouseButton.new()
		ev_mouse.button_index = MOUSE_BUTTON_LEFT
		InputMap.action_add_event("shoot", ev_mouse)
