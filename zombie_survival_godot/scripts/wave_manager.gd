extends Node

signal wave_started(wave_number: int, total_zombies: int)
signal wave_completed(wave_number: int)
signal zombies_remaining_changed(remaining: int)
signal zombie_killed_event(score: int)

@export var regular_zombie_scene: PackedScene
@export var fast_zombie_scene: PackedScene
@export var tank_zombie_scene: PackedScene
@export var arena_node: Node2D
@export var zombie_container: Node2D

var current_wave: int = 0
var zombies_to_spawn_total: int = 0
var zombies_spawned_so_far: int = 0
var zombies_alive: int = 0
var is_wave_in_progress: bool = false
var spawn_interval: float = 1.2

var spawn_timer: Timer
var intermission_timer: Timer
var wave_sfx: AudioStreamPlayer

func _init() -> void:
	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	intermission_timer = Timer.new()
	intermission_timer.one_shot = true
	wave_sfx = AudioStreamPlayer.new()

func _ready() -> void:
	# Configure timers
	if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	if not spawn_timer.is_inside_tree():
		add_child(spawn_timer)
	
	if not intermission_timer.timeout.is_connected(_on_intermission_timer_timeout):
		intermission_timer.timeout.connect(_on_intermission_timer_timeout)
	if not intermission_timer.is_inside_tree():
		add_child(intermission_timer)
	
	# Configure wave start sound
	var sfx_stream = load("res://assets/audio/wave_start.wav")
	if sfx_stream:
		wave_sfx.stream = sfx_stream
		wave_sfx.volume_db = -1.0
	if not wave_sfx.is_inside_tree():
		add_child(wave_sfx)

func start_first_wave() -> void:
	current_wave = 0
	start_next_wave()

func start_next_wave() -> void:
	current_wave += 1
	zombies_to_spawn_total = 6 + current_wave * 4
	zombies_spawned_so_far = 0
	zombies_alive = 0
	is_wave_in_progress = true
	
	# Spawn rate increases with waves
	spawn_interval = max(0.4, 1.4 - current_wave * 0.08)
	
	if wave_sfx and wave_sfx.stream:
		wave_sfx.play()
		
	emit_signal("wave_started", current_wave, zombies_to_spawn_total)
	emit_signal("zombies_remaining_changed", zombies_to_spawn_total)
	
	spawn_timer.start(0.8) # Brief pause before first zombie emerges

func _on_spawn_timer_timeout() -> void:
	if not is_wave_in_progress or zombies_spawned_so_far >= zombies_to_spawn_total:
		return
		
	_spawn_zombie()
	zombies_spawned_so_far += 1
	
	if zombies_spawned_so_far < zombies_to_spawn_total:
		spawn_timer.start(spawn_interval)

func _spawn_zombie() -> void:
	var scene_to_spawn = _choose_zombie_type()
	if not scene_to_spawn:
		return
		
	var zombie = scene_to_spawn.instantiate()
	var spawn_pos = Vector2.ZERO
	if arena_node and arena_node.has_method("get_random_spawn_position"):
		spawn_pos = arena_node.get_random_spawn_position()
	else:
		spawn_pos = Vector2(randf_range(-700, 700), randf_range(-450, 450))
		
	zombie.global_position = spawn_pos
	zombie.killed.connect(_on_zombie_killed)
	
	if zombie_container:
		zombie_container.add_child(zombie)
	else:
		add_child(zombie)
		
	zombies_alive += 1

func _choose_zombie_type() -> PackedScene:
	var roll = randf()
	
	# Wave 1: 100% walkers
	if current_wave == 1:
		return regular_zombie_scene
		
	# Wave 2: 25% runners, 75% walkers
	if current_wave == 2:
		if roll < 0.25 and fast_zombie_scene:
			return fast_zombie_scene
		return regular_zombie_scene
		
	# Wave 3+: introduce tanks and more runners
	var tank_chance = min(0.25, 0.08 + (current_wave - 3) * 0.04)
	var fast_chance = min(0.40, 0.25 + (current_wave - 3) * 0.03)
	
	if roll < tank_chance and tank_zombie_scene:
		return tank_zombie_scene
	elif roll < (tank_chance + fast_chance) and fast_zombie_scene:
		return fast_zombie_scene
	else:
		return regular_zombie_scene

func _on_zombie_killed(_zombie_node: Node2D, score: int) -> void:
	zombies_alive = max(0, zombies_alive - 1)
	var remaining = (zombies_to_spawn_total - zombies_spawned_so_far) + zombies_alive
	
	emit_signal("zombies_remaining_changed", remaining)
	emit_signal("zombie_killed_event", score)
	
	if zombies_spawned_so_far >= zombies_to_spawn_total and zombies_alive <= 0:
		_complete_wave()

func _complete_wave() -> void:
	is_wave_in_progress = false
	emit_signal("wave_completed", current_wave)
	# 3.5 seconds intermission before next wave
	intermission_timer.start(3.5)

func _on_intermission_timer_timeout() -> void:
	start_next_wave()
