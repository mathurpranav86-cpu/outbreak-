extends CanvasLayer

signal game_resumed()
signal restart_requested()

@onready var resume_btn: Button = $Control/PanelContainer/Margin/VBox/ResumeBtn
@onready var restart_btn: Button = $Control/PanelContainer/Margin/VBox/RestartBtn
@onready var menu_btn: Button = $Control/PanelContainer/Margin/VBox/MenuBtn

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	if resume_btn:
		resume_btn.pressed.connect(_on_resume_pressed)
	if restart_btn:
		restart_btn.pressed.connect(_on_restart_pressed)
	if menu_btn:
		menu_btn.pressed.connect(_on_menu_pressed)

func show_pause_menu() -> void:
	visible = true
	get_tree().paused = true

func hide_pause_menu() -> void:
	visible = false
	get_tree().paused = false

func _on_resume_pressed() -> void:
	hide_pause_menu()
	emit_signal("game_resumed")

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
