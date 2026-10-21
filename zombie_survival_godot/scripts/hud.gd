extends CanvasLayer

signal pause_requested()

@onready var health_bar: ProgressBar = $Control/TopLeft/HealthBar
@onready var health_label: Label = $Control/TopLeft/HealthLabel
@onready var weapon_label: Label = $Control/TopLeft/WeaponLabel
@onready var ammo_label: Label = $Control/TopLeft/AmmoLabel

@onready var wave_label: Label = $Control/TopCenter/WaveLabel
@onready var zombies_label: Label = $Control/TopCenter/ZombiesLabel

@onready var kills_label: Label = $Control/TopRight/KillsLabel
@onready var score_label: Label = $Control/TopRight/ScoreLabel
@onready var pause_btn: Button = $Control/TopRight/PauseButton

@onready var banner: PanelContainer = $Control/CenterBanner
@onready var banner_title: Label = $Control/CenterBanner/Margin/VBox/BannerTitle
@onready var banner_subtitle: Label = $Control/CenterBanner/Margin/VBox/BannerSubtitle

var current_weapon_name: String = "Pistol"
var current_ammo: int = 12
var max_mag: int = 12
var is_reloading: bool = false
var banner_tween: Tween = null

func _ready() -> void:
	if pause_btn:
		pause_btn.pressed.connect(_on_pause_pressed)
	if banner:
		banner.modulate = Color(1, 1, 1, 0)

func update_health(current: float, max_hp: float) -> void:
	if health_bar:
		health_bar.max_value = max_hp
		health_bar.value = current
	if health_label:
		health_label.text = "HP: %d / %d" % [int(current), int(max_hp)]

func update_ammo(cur: int, maximum: int) -> void:
	current_ammo = cur
	max_mag = maximum
	_refresh_ammo_display()

func set_reloading_status(reloading: bool) -> void:
	is_reloading = reloading
	_refresh_ammo_display()

func _refresh_ammo_display() -> void:
	if not ammo_label:
		return
	if is_reloading:
		ammo_label.text = "AMMO: RELOADING..."
		ammo_label.modulate = Color(1.0, 0.85, 0.2)
	else:
		ammo_label.text = "AMMO: %d / ∞" % [current_ammo]
		ammo_label.modulate = Color.WHITE

func update_wave(wave_num: int) -> void:
	if wave_label:
		wave_label.text = "WAVE %d" % wave_num
	show_wave_banner("WAVE %d" % wave_num, "SURVIVE THE HORDE!")

func update_zombies_remaining(remaining: int) -> void:
	if zombies_label:
		zombies_label.text = "ZOMBIES REMAINING: %d" % remaining

func update_kills(kills: int) -> void:
	if kills_label:
		kills_label.text = "KILLS: %d" % kills

func update_score(score: int) -> void:
	if score_label:
		score_label.text = "SCORE: %d" % score

func show_wave_banner(title: String, subtitle: String) -> void:
	if not banner:
		return
	banner_title.text = title
	banner_subtitle.text = subtitle
	
	if banner_tween and banner_tween.is_valid():
		banner_tween.kill()
		
	banner_tween = create_tween()
	banner.modulate = Color(1, 1, 1, 0)
	banner.scale = Vector2(0.85, 0.85)
	
	banner_tween.parallel().tween_property(banner, "modulate:a", 1.0, 0.3)
	banner_tween.parallel().tween_property(banner, "scale", Vector2(1.0, 1.0), 0.3)
	banner_tween.tween_interval(1.4)
	banner_tween.tween_property(banner, "modulate:a", 0.0, 0.4)

func _on_pause_pressed() -> void:
	emit_signal("pause_requested")
