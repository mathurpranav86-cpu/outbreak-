extends CanvasLayer

signal restart_requested()

@onready var waves_label: Label = $Control/PanelContainer/Margin/VBox/StatsPanel/StatsMargin/StatsVBox/WavesLabel
@onready var kills_label: Label = $Control/PanelContainer/Margin/VBox/StatsPanel/StatsMargin/StatsVBox/KillsLabel
@onready var score_label: Label = $Control/PanelContainer/Margin/VBox/StatsPanel/StatsMargin/StatsVBox/ScoreLabel
@onready var time_label: Label = $Control/PanelContainer/Margin/VBox/StatsPanel/StatsMargin/StatsVBox/TimeLabel

@onready var restart_btn: Button = $Control/PanelContainer/Margin/VBox/Buttons/RestartBtn
@onready var menu_btn: Button = $Control/PanelContainer/Margin/VBox/Buttons/MenuBtn
@onready var game_over_sfx: AudioStreamPlayer = $GameOverSFX

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	if restart_btn:
		restart_btn.pressed.connect(_on_restart_pressed)
	if menu_btn:
		menu_btn.pressed.connect(_on_menu_pressed)

func show_game_over(wave: int, kills: int, score: int, elapsed_seconds: float) -> void:
	visible = true
	get_tree().paused = true
	
	var minutes = int(elapsed_seconds) / 60
	var seconds = int(elapsed_seconds) % 60
	
	if waves_label:
		waves_label.text = "Waves Reached: %d" % wave
	if kills_label:
		kills_label.text = "Zombies Eliminated: %d" % kills
	if score_label:
		score_label.text = "Final Score: %d" % score
	if time_label:
		time_label.text = "Survival Time: %02d:%02d" % [minutes, seconds]
		
	if game_over_sfx:
		game_over_sfx.play()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
