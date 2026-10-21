extends Node2D

@onready var spawn_points: Node2D = $SpawnPoints

func get_random_spawn_position() -> Vector2:
	if spawn_points and spawn_points.get_child_count() > 0:
		var markers = spawn_points.get_children()
		var random_marker = markers[randi() % markers.size()]
		# Add small random jitter so zombies don't stack exactly on the same coordinate
		var jitter = Vector2(randf_range(-30, 30), randf_range(-30, 30))
		return random_marker.global_position + jitter
	else:
		# Fallback to random perimeter edge
		var side = randi() % 4
		match side:
			0: return Vector2(randf_range(-850, 850), -550) # Top
			1: return Vector2(randf_range(-850, 850), 550)  # Bottom
			2: return Vector2(-850, randf_range(-550, 550)) # Left
			_: return Vector2(850, randf_range(-550, 550))  # Right
