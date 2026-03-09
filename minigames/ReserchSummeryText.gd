extends CanvasLayer

signal computer_clicked

# Paths from UI CanvasLayer node
@onready var hide_button = $HideButton
@onready var reserch_sheet = $Control/ReserchSheet
@onready var reserch_summery_label = $Control/ReserchSheet/ReserchSummeryLabel
@onready var reserch_summery_text = $Control/ReserchSummery

var phase_data = {
	0: {  # After Sunspot Memory
		"title": "Sunspot Research Summary",
		"content": "The dark spots on the surface of the sun are called sunspots. They vary in size and regularity, and are caused by disturbances in the magnetic field of the sun. The largest sunspot ever recorded covered an area of 18 billion square kilometers in 1947 - many times larger than Earth.\n\nSunspots often appear in pairs or groups. In a sunspot pair, the two spots have opposite magnetic polarities, with magnetic field lines looping between them. These active regions can release solar prominences and solar flares.\n\nSunspots provide key evidence for the sun's rotation. By tracing their movement across the solar surface, scientists have determined that the sun rotates faster at its equator (about 25 days) than at its poles (about 34 days)."
	},
	1: {  # After Solar Flare
		"title": "Solar Flare Research Summary",
		"content": "Solar flares always occur above active sunspots, releasing enormous quantities of gas and charged particles. They are caused by rapidly changing magnetic fields around sunspots - when magnetic lines become too tangled, they suddenly break and realign.\n\nSolar flares are the largest explosive events in our solar system, lasting from minutes to hours. They emit high-energy X-rays and ultraviolet radiation.\n\nUnlike solar prominences (which are stable, looped structures of plasma), flares are sudden explosions of energy. They can disrupt high-frequency radio communications, affect power grids, and damage satellites through increased space radiation."
	},
	2: {  # Final summary
		"title": "Research Complete",
		"content": "Congratulations! You've successfully analyzed key solar phenomena. Your research has helped us better understand the sun's complex behavior and its effects on our solar system.\n\nMission Complete!"
	}
}

func _ready():
	print("=== RESEARCH SUMMARY UI LOADED ===")
	print("UI Node Path: ", get_path())
	
	# Verify all nodes are found
	print("Hide button: ", "✅ FOUND" if hide_button else "❌ MISSING")
	print("Summary Label: ", "✅ FOUND" if reserch_summery_label else "❌ MISSING")
	print("Summary Text: ", "✅ FOUND" if reserch_summery_text else "❌ MISSING")
	
	# Connect hide button
	if hide_button:
		hide_button.pressed.connect(_on_hide_button_pressed)
		print("Hide button connected")
	
	# Start visible
	show_all()

func set_phase(phase_index):
	print("\n=== SET_PHASE CALLED ===")
	print("Phase index: ", phase_index)
	
	var data = phase_data.get(phase_index, phase_data[0])
	print("Title: ", data["title"])
	
	# Update title label
	if reserch_summery_label:
		reserch_summery_label.text = data["title"]
		print("Title updated")
	
	# Update text node
	if reserch_summery_text:
		reserch_summery_text.text = data["content"]
		print("Content updated (", len(data["content"]), " characters)")
	
	# Make sure everything is visible
	show_all()

func show_all():
	print("Showing all UI elements")
	if reserch_summery_label:
		reserch_summery_label.visible = true
	if reserch_summery_text:
		reserch_summery_text.visible = true
	if hide_button:
		hide_button.visible = true

func hide_all():
	print("Hiding all UI elements")
	if reserch_summery_label:
		reserch_summery_label.visible = false
	if reserch_summery_text:
		reserch_summery_text.visible = false
	if hide_button:
		hide_button.visible = false

func _on_hide_button_pressed():
	print("Hide button pressed")
	hide_all()
	# Emit signal that computer can now be clicked
	computer_clicked.emit()
