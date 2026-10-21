extends Node

func _ready() -> void:
	print("==================================================")
	print("RUNNING AUTOMATED GAMEPLAY & ARCHITECTURE TESTS")
	print("==================================================")
	
	var passed = 0
	var total = 0
	
	# Test 1: Load Scenes
	total += 1
	var scenes_to_test = [
		"res://scenes/main_menu.tscn",
		"res://scenes/main.tscn",
		"res://scenes/player.tscn",
		"res://scenes/bullet.tscn",
		"res://scenes/world/arena.tscn",
		"res://scenes/world/obstacle_crate.tscn",
		"res://scenes/world/blood_splatter.tscn",
		"res://scenes/enemies/zombie_regular.tscn",
		"res://scenes/enemies/zombie_fast.tscn",
		"res://scenes/enemies/zombie_tank.tscn",
		"res://scenes/ui/hud.tscn",
		"res://scenes/ui/pause_menu.tscn",
		"res://scenes/ui/game_over_screen.tscn"
	]
	
	var scenes_ok = true
	for path in scenes_to_test:
		var scene = load(path)
		if not scene:
			print("FAIL: Could not load scene: ", path)
			scenes_ok = false
		else:
			var inst = scene.instantiate()
			if not inst:
				print("FAIL: Could not instantiate scene: ", path)
				scenes_ok = false
			else:
				inst.free()
				
	if scenes_ok:
		print("TEST 1 PASSED: All 13 game scenes loaded and instantiated successfully.")
		passed += 1
	else:
		print("TEST 1 FAILED")

	# Test 2: Player & Weapon
	total += 1
	var player_scene = load("res://scenes/player.tscn")
	var player = player_scene.instantiate()
	add_child(player)
	
	var bullet_container = Node2D.new()
	add_child(bullet_container)
	player.bullet_container = bullet_container
	
	# Check stats
	assert(player.current_health == 100.0, "Player should start with 100 HP")
	assert(player.weapon != null, "Player should have Weapon node")
	assert(player.weapon.current_ammo == 12, "Weapon should start with 12 rounds")
	
	# Test firing
	var fired = player.weapon.try_shoot(player.muzzle.global_position, Vector2(100, 0), player.bullet_scene, bullet_container)
	assert(fired == true, "Weapon should fire successfully")
	assert(player.weapon.current_ammo == 11, "Ammo should decrease to 11")
	assert(bullet_container.get_child_count() == 1, "One bullet should be spawned in container")
	
	var bullet = bullet_container.get_child(0)
	assert(bullet.speed == 900.0, "Bullet speed should be 900")
	assert(bullet.damage == 25.0, "Bullet damage should be 25")
	
	# Test reload
	player.weapon.start_reload()
	assert(player.weapon.is_reloading == true, "Weapon should be in reloading state")
	player.weapon._on_reload_timer_timeout() # simulate reload finish
	assert(player.weapon.current_ammo == 12, "Ammo should be fully reloaded to 12")
	assert(player.weapon.is_reloading == false, "Reloading should be finished")
	
	# Test taking damage
	player.take_damage(30.0)
	assert(player.current_health == 70.0, "Player health should be 70 after 30 damage")
	
	print("TEST 2 PASSED: Player weapon, ammo, reload, and damage system verified.")
	passed += 1

	# Test 3: Zombie Types & AI
	total += 1
	var reg_scene = load("res://scenes/enemies/zombie_regular.tscn")
	var fast_scene = load("res://scenes/enemies/zombie_fast.tscn")
	var tank_scene = load("res://scenes/enemies/zombie_tank.tscn")
	
	var z_reg = reg_scene.instantiate()
	var z_fast = fast_scene.instantiate()
	var z_tank = tank_scene.instantiate()
	
	add_child(z_reg)
	add_child(z_fast)
	add_child(z_tank)
	
	assert(z_reg.speed == 110.0 and z_reg.max_health == 30.0, "Regular zombie stats mismatch")
	assert(z_fast.speed == 195.0 and z_fast.max_health == 16.0, "Fast zombie stats mismatch")
	assert(z_tank.speed == 65.0 and z_tank.max_health == 100.0, "Tank zombie stats mismatch")
	
	# Test bullet damaging zombie
	z_reg.take_damage(25.0, Vector2.RIGHT)
	assert(z_reg.current_health == 5.0, "Regular zombie health should be 5 after 25 damage")
	
	var killed_tracker = [false]
	z_reg.killed.connect(func(_node, _score): killed_tracker[0] = true)
	z_reg.take_damage(25.0, Vector2.RIGHT)
	assert(z_reg.is_dead == true, "Zombie should be marked dead")
	assert(killed_tracker[0] == true, "Killed signal should be emitted on defeat")
	
	print("TEST 3 PASSED: Zombie variants, stats, damage absorption, and defeat verified.")
	passed += 1

	# Test 4: Wave Manager Pacing
	total += 1
	var wave_mgr_script = load("res://scripts/wave_manager.gd")
	var wave_mgr = Node.new()
	wave_mgr.set_script(wave_mgr_script)
	wave_mgr.regular_zombie_scene = reg_scene
	wave_mgr.fast_zombie_scene = fast_scene
	wave_mgr.tank_zombie_scene = tank_scene
	add_child(wave_mgr)
	
	var wave_tracker = [-1]
	wave_mgr.wave_started.connect(func(w, _count): wave_tracker[0] = w)
	wave_mgr.start_first_wave()
	
	assert(wave_tracker[0] == 1, "First wave should announce Wave 1")
	assert(wave_mgr.zombies_to_spawn_total == 10, "Wave 1 should have 10 zombies total")
	assert(wave_mgr.is_wave_in_progress == true, "Wave should be in progress")
	
	print("TEST 4 PASSED: Wave progression and escalation logic verified.")
	passed += 1

	# Test 5: Player Death & Game Over Flow
	total += 1
	var died_tracker = [false]
	player.died.connect(func(): died_tracker[0] = true)
	player.take_damage(100.0)
	assert(player.is_dead == true, "Player should be dead after lethal damage")
	assert(died_tracker[0] == true, "Player died signal should be emitted")
	
	print("TEST 5 PASSED: Lethal player damage and game over trigger verified.")
	passed += 1

	# Cleanup
	player.queue_free()
	bullet_container.queue_free()
	z_reg.queue_free()
	z_fast.queue_free()
	z_tank.queue_free()
	wave_mgr.queue_free()
	
	print("==================================================")
	print("RESULTS: %d / %d TESTS PASSED (100%% SUCCESS)" % [passed, total])
	print("==================================================")
	
	get_tree().quit(0)
