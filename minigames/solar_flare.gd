extends Node2D

signal phase_completed

# Paths relative to SolarFlare root node
@onready var sprite: AnimatedSprite2D = $Sun/AnimatedSprite2D
@onready var area: Area2D = $Sun/Area2D
@onready var camera = $Camera2D

var has_played: bool = false
var game_active = false

func _ready():
	print("Solar Flare: Script loaded on root node")
	
	# Make sure animation doesn't loop
	if sprite:
		if sprite.sprite_frames.has_animation("default"):
			sprite.sprite_frames.set_animation_loop("default", false)
			print("Solar Flare: Animation set to not loop")
	
	# Hide ALL UI elements
	hide_all_ui()
	
	# Hide main scene sun
	hide_main_sun()
	
	# Setup area
	if area:
		area.input_event.connect(_on_area_input_event)
		area.input_pickable = true
		print("Solar Flare: Area connected")
	else:
		print("Solar Flare: ERROR - Area not found")
	
	# Start camera movement
	start_camera_move()

func hide_all_ui():
	# Hide UI in this scene
	var ui_node = get_node_or_null("UI")
	if ui_node:
		ui_node.visible = false
		print("Solar Flare: Scene UI hidden")
	
	# Hide main scene UI elements
	var main_scene = get_node("/root/AnalizeScene")
	if main_scene:
		var main_ui = main_scene.get_node_or_null("UI")
		if main_ui:
			main_ui.visible = false
			print("Solar Flare: Main scene UI hidden")
		
		# Also hide specific UI elements just in case
		var mission = main_scene.get_node_or_null("UI/Control/MissionLabel")
		var warning = main_scene.get_node_or_null("UI/Control/WarningLabel")
		var remaining = main_scene.get_node_or_null("UI/Control/RemainingAttempts")
		
		if mission:
			mission.visible = false
		if warning:
			warning.visible = false
		if remaining:
			remaining.visible = false

func show_all_ui():
	# Show main scene UI again
	var main_scene = get_node("/root/AnalizeScene")
	if main_scene:
		var main_ui = main_scene.get_node_or_null("UI")
		if main_ui:
			main_ui.visible = true
			print("Solar Flare: Main scene UI shown")

func hide_main_sun():
	var main_scene = get_node("/root/AnalizeScene")
	if main_scene:
		var main_sun = main_scene.get_node_or_null("Sun/Node2D/AnimatedSprite2D")
		var main_mag = main_scene.get_node_or_null("Sun/SunMagnetogram")
		var main_cross = main_scene.get_node_or_null("Sun/SunCrossSection")
		
		if main_sun:
			main_sun.visible = false
		if main_mag:
			main_mag.visible = false
		if main_cross:
			main_cross.visible = false
		
		print("Solar Flare: Main sun hidden")

func start_camera_move():
	if not camera:
		print("Solar Flare: ERROR - Camera not found!")
		return
		
	print("Solar Flare: Starting camera move")
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(camera, "zoom", Vector2(0.1, 0.1), 2.0)
	tween.tween_property(camera, "position", Vector2(0, 0), 1.5)
	
	await tween.finished
	
	print("Solar Flare: Camera ready")
	game_active = true
	print("Solar Flare: Now click the sun!")

func _on_area_input_event(viewport, event, shape_idx):
	if not game_active or has_played:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Solar Flare: Sun clicked!")
			trigger_flare()

func trigger_flare():
	print("SOLAR FLARE TRIGGERED!")
	game_active = false
	has_played = true
	
	if sprite:
		print("Solar Flare: Playing animation")
		sprite.play("default")
		
		await sprite.animation_finished
		print("Solar Flare: Animation finished")
		
		await get_tree().create_timer(1.0).timeout
		
		# Show main sun and UI again
		show_main_sun()
		show_all_ui()
		
		await get_tree().create_timer(1.0).timeout
		
		print("Solar Flare: Phase complete")
		phase_completed.emit()
	else:
		print("Solar Flare: ERROR - Sprite not found!")

func show_main_sun():
	var main_scene = get_node("/root/AnalizeScene")
	if main_scene:
		var main_sun = main_scene.get_node_or_null("Sun/Node2D/AnimatedSprite2D")
		if main_sun:
			main_sun.visible = true
			print("Solar Flare: Main sun shown")

func _exit_tree():
	show_main_sun()
	show_all_ui()
