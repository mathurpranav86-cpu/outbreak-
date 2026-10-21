extends Control

@onready var start_btn: Button = $CenterContainer/VBox/MenuPanel/Margin/MenuButtons/StartBtn
@onready var controls_btn: Button = $CenterContainer/VBox/MenuPanel/Margin/MenuButtons/ControlsBtn
@onready var quit_btn: Button = $CenterContainer/VBox/MenuPanel/Margin/MenuButtons/QuitBtn
@onready var controls_panel: PanelContainer = $ControlsPanel
@onready var close_controls_btn: Button = $ControlsPanel/Margin/VBox/CloseControlsBtn

func _ready() -> void:
	# Reset cursor to standard arrow for menu navigation
	Input.set_custom_mouse_cursor(null)
	
	if start_btn:
		start_btn.pressed.connect(_on_start_pressed)
	if controls_btn:
		controls_btn.pressed.connect(_on_controls_pressed)
	if quit_btn:
		quit_btn.pressed.connect(_on_quit_pressed)
	if close_controls_btn:
		close_controls_btn.pressed.connect(_on_close_controls_pressed)
		
	if controls_panel:
		controls_panel.visible = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_controls_pressed() -> void:
	if controls_panel:
		controls_panel.visible = true

func _on_close_controls_pressed() -> void:
	if controls_panel:
		controls_panel.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
