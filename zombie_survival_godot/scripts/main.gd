extends Node2D

@onready var arena: Node2D = $Arena
@onready var player: CharacterBody2D = $Player
@onready var wave_manager: Node = $WaveManager
@onready var hud: CanvasLayer = $HUD
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var zombies_node: Node2D = $Zombies
@onready var projectiles_node: Node2D = $Projectiles

var total_kills: int = 0
var total_score: int = 0
var elapsed_time: float = 0.0
var is_game_active: bool = true

func _ready() -> void:
	# Set custom crosshair cursor
	var crosshair_tex = load("res://assets/sprites/crosshair.png")
	if crosshair_tex:
		Input.set_custom_mouse_cursor(crosshair_tex, Input.CURSOR_ARROW, Vector2(12, 12))
		
	# Wire player
	if player:
		player.bullet_container = projectiles_node
		player.health_changed.connect(_on_player_health_changed)
		player.ammo_changed.connect(_on_player_ammo_changed)
		player.reloading_status.connect(_on_player_reloading_status)
		player.died.connect(_on_player_died)
		
	# Wire wave manager
	if wave_manager:
		wave_manager.arena_node = arena
		wave_manager.zombie_container = zombies_node
		wave_manager.wave_started.connect(_on_wave_started)
		wave_manager.zombies_remaining_changed.connect(_on_zombies_remaining_changed)
		wave_manager.zombie_killed_event.connect(_on_zombie_killed)
		
	# Wire HUD
	if hud:
		hud.pause_requested.connect(_toggle_pause)
		
	# Start match
	if wave_manager:
		wave_manager.start_first_wave()

func _process(delta: float) -> void:
	if is_game_active and not get_tree().paused:
		elapsed_time += delta
		
	if Input.is_action_just_pressed("pause"):
		_toggle_pause()

func _toggle_pause() -> void:
	if not is_game_active:
		return
	if get_tree().paused:
		pause_menu.hide_pause_menu()
	else:
		pause_menu.show_pause_menu()

func _on_player_health_changed(cur: float, max_hp: float) -> void:
	if hud:
		hud.update_health(cur, max_hp)

func _on_player_ammo_changed(cur: int, max_mag: int) -> void:
	if hud:
		hud.update_ammo(cur, max_mag)

func _on_player_reloading_status(reloading: bool) -> void:
	if hud:
		hud.set_reloading_status(reloading)

func _on_wave_started(wave_num: int, _total_zombies: int) -> void:
	if hud:
		hud.update_wave(wave_num)

func _on_zombies_remaining_changed(remaining: int) -> void:
	if hud:
		hud.update_zombies_remaining(remaining)

func _on_zombie_killed(score: int) -> void:
	total_kills += 1
	total_score += score
	if hud:
		hud.update_kills(total_kills)
		hud.update_score(total_score)

func _on_player_died() -> void:
	is_game_active = false
	var timer = get_tree().create_timer(1.2)
	timer.timeout.connect(func():
		if game_over_screen:
			game_over_screen.show_game_over(wave_manager.current_wave, total_kills, total_score, elapsed_time)
	)
