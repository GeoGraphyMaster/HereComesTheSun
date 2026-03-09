extends Node2D

enum SunView { NORMAL, MAGNETOGRAM, CROSS_SECTION }
var current_view = SunView.NORMAL

@onready var normal_sun = get_node("/root/AnalizeScene/Sun/Node2D/AnimatedSprite2D")
@onready var magnetogram = get_node("/root/AnalizeScene/Sun/SunMagnetogram")
@onready var cross_section = get_node("/root/AnalizeScene/Sun/SunCrossSection")

func _ready():
	# Start with normal view
	set_view(SunView.NORMAL)

func set_view(view: SunView):
	current_view = view
	
	# Hide all first
	normal_sun.visible = false
	magnetogram.visible = false
	cross_section.visible = false
	
	# Show selected view
	match view:
		SunView.NORMAL:
			normal_sun.visible = true
			print("View set to: NORMAL")
		SunView.MAGNETOGRAM:
			magnetogram.visible = true
			print("View set to: MAGNETOGRAM")
		SunView.CROSS_SECTION:
			cross_section.visible = true
			print("View set to: CROSS_SECTION")

# Functions for buttons to call
func toggle_magnetic():
	match current_view:
		SunView.NORMAL:
			set_view(SunView.MAGNETOGRAM)
		SunView.MAGNETOGRAM:
			set_view(SunView.NORMAL)
		SunView.CROSS_SECTION:
			set_view(SunView.MAGNETOGRAM)  # From cross, go to magnetic

func toggle_cross_section():
	match current_view:
		SunView.NORMAL:
			set_view(SunView.CROSS_SECTION)
		SunView.CROSS_SECTION:
			set_view(SunView.NORMAL)
		SunView.MAGNETOGRAM:
			set_view(SunView.CROSS_SECTION)  # From magnetic, go to cross
