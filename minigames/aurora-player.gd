extends Area2D

enum State { FLYING, CAPTURED }

var state = State.FLYING
var velocity = Vector2.ZERO
var speed = 200.0          # flying speed
var steering_strength = 5.0
var magnetic_zone = null
var path_follow = null
var capture_offset = 0.0
var capture_speed = 100.0  # speed along path when captured

func _ready():
	# Connect signals from MagneticZone
	var zone = get_node("../MagneticZone")
	zone.body_entered.connect(_on_magnetic_zone_entered)
	zone.body_exited.connect(_on_magnetic_zone_exited)
	
	# Get reference to PathFollow2D
	path_follow = get_node("../Path2D/PathFollow2D")
	
	# Connect to Sun's launch signal
	var sun = get_node("../Sun")
	sun.launched.connect(_on_sun_launched)

func _on_sun_launched(start_pos, vel):
	global_position = start_pos
	velocity = vel
	state = State.FLYING
	# Ensure player is not captured
	path_follow.offset = 0  # reset

func _on_magnetic_zone_entered(body):
	if body == self and state == State.FLYING:
		# Enter magnetic capture
		state = State.CAPTURED
		# Find closest point on path to current position
		var closest_offset = _find_closest_path_offset(global_position)
		path_follow.offset = closest_offset
		# Snap player to path
		global_position = path_follow.global_position

func _on_magnetic_zone_exited(body):
	if body == self and state == State.CAPTURED:
		# Lost in space? Actually shouldn't happen if path ends inside zone.
		state = State.FLYING

func _find_closest_path_offset(target_pos):
	# Simple brute force sampling along the path
	var curve = path_follow.get_parent().curve
	var steps = 100
	var best_offset = 0
	var best_dist = INF
	for i in range(steps+1):
		var offset = curve.get_length() * i / steps
		var point = curve.sample_baked(offset)
		var dist = target_pos.distance_to(point)
		if dist < best_dist:
			best_dist = dist
			best_offset = offset
	return best_offset

func _process(delta):
	if state == State.FLYING:
		_flying_update(delta)
	elif state == State.CAPTURED:
		_captured_update(delta)

func _flying_update(delta):
	# Gentle steering towards mouse
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	velocity += direction * steering_strength
	velocity = velocity.limit_length(speed)
	global_position += velocity * delta
	
	# Keep within screen bounds (optional)
	var viewport = get_viewport_rect().size
	global_position = global_position.clamp(Vector2.ZERO, viewport)

func _captured_update(delta):
	# Control speed along path with mouse Y (up/down)
	var mouse_y = get_viewport().get_mouse_position().y
	var center_y = get_viewport_rect().size.y / 2
	var dir = sign(center_y - mouse_y)  # positive if mouse above center (move forward)
	var move = dir * capture_speed * delta
	path_follow.offset += move
	# Clamp offset to path length
	var max_offset = path_follow.get_parent().curve.get_length()
	path_follow.offset = clamp(path_follow.offset, 0, max_offset)
	# Update player position
	global_position = path_follow.global_position
