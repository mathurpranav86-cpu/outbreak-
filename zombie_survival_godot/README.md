# Outbreak: 2D Zombie Survival (Godot 4)

A fast-paced, top-down 2D pixel-art zombie survival game built with **Godot 4 and GDScript**.

---

## 🎮 Controls

| Action | Controls |
| :--- | :--- |
| **Move** | `W`, `A`, `S`, `D` or Arrow Keys |
| **Aim** | Mouse Cursor (Custom reticle) |
| **Shoot** | Left Mouse Button |
| **Reload** | `R` (or automatic when empty) |
| **Pause / Resume** | `Esc` or `P` |

---

## 🕹️ Game Features

1. **Player Controller**
   - 8-directional smooth movement using `CharacterBody2D` with physical sliding against obstacles.
   - Omnidirectional rotation tracking the cursor using `look_at(get_global_mouse_position())`.
   - Dynamic tactical crosshair cursor and muzzle flash bursts.
   - Player health system with visual damage flash and game-over state.

2. **Weapon System (Modular Architecture)**
   - Modular `Weapon` class (`scripts/weapon.gd`) with customizable damage, fire rate, magazine capacity, reload time, and bullet spread.
   - Fast-shooting tactical pistol with 12-round magazines and unlimited ammunition reserves.
   - Accurate projectile trajectories (`Area2D`) with obstacle and enemy collision handling.

3. **Zombie Horde & AI Types**
   - **Walker (Regular Zombie)**: Balanced speed (110 px/s) and endurance (30 HP).
   - **Runner (Fast Zombie)**: Agile, terrifying crimson sprinter (195 px/s, 16 HP) that closes gaps quickly.
   - **Brute (Tank Zombie)**: Massive, hulking juggernaut (65 px/s, 100 HP, 30 damage) with heavy knockback resistance.
   - Custom separation and path steering around physical obstacles.
   - Visceral impact feedback: directional knockback, damage flash, audio splat, and particle blood splatters.

4. **Escalating Wave Progression**
   - Waves scale dynamically: `Total Zombies = 6 + Wave * 4`.
   - Higher waves progressively introduce Runners and Brutes with shorter spawn intervals.
   - Interactive wave announcement banners and 3.5s tactical intermissions between waves.

5. **Top-Down Arena Environment**
   - High-contrast industrial concrete arena bounded by impenetrable perimeter barriers.
   - Tactical crates providing chokepoints and kiting opportunities.
   - Smooth `Camera2D` tracking with interpolation.

6. **Comprehensive UI & Menus**
   - **HUD**: Player health bar with live values, wave count, zombies remaining, kill counter, score, and ammo display (`12 / ∞`).
   - **Main Menu**: Atmospheric title screen with quick start, interactive controls guide, and quit button.
   - **Pause Menu**: In-game pause overlay (`Esc` / `P`) with Resume, Restart, and Main Menu options.
   - **Game Over Screen**: Summary breakdown (Wave Reached, Zombies Eliminated, Final Score, Survival Time) with immediate restart.

---

## 🚀 How to Run the Game on Windows

### Option 1: Double-Click Launcher
Double-click `run_game.bat` inside the project folder. It will automatically detect Godot and launch the game.

### Option 2: Command Line (PowerShell)
```powershell
$godot = (Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\WinGet\Packages" -Filter "*godot*console.exe" -Recurse).FullName
& $godot --path "C:\Users\Pranav Mathur\.gemini\antigravity-ide\scratch\zombie_survival_godot"
```

### Option 3: Godot 4 Editor
1. Open Godot 4.
2. Click **Import**.
3. Select the `project.godot` file in this directory.
4. Click **Import & Edit**, then press `F5` to play!

---

## 📁 Project Structure

```
zombie_survival_godot/
├── project.godot                # Godot 4 engine configuration & input mappings
├── run_game.bat                 # One-click Windows game launcher
├── icon.svg                     # Project icon
├── assets/
│   ├── sprites/                 # Procedurally generated pixel-art textures
│   │   ├── player.png           # Survivor with tactical vest & sidearm
│   │   ├── zombie_regular.png   # Walker zombie
│   │   ├── zombie_fast.png      # Runner zombie
│   │   ├── zombie_tank.png      # Brute zombie
│   │   ├── bullet.png           # Glowing tracer round
│   │   ├── floor_tile.png       # Concrete slab tile
│   │   ├── wall_tile.png        # Reinforced steel barrier
│   │   ├── crate.png            # Tactical supply crate
│   │   ├── blood_particle.png   # Impact blood droplet
│   │   ├── muzzle_flash.png     # Weapon discharge burst
│   │   └── crosshair.png        # Tactical aiming reticle
│   └── audio/                   # 16-bit PCM sound effects
│       ├── shoot.wav
│       ├── hit.wav
│       ├── zombie_die.wav
│       ├── player_hurt.wav
│       ├── reload.wav
│       ├── wave_start.wav
│       └── game_over.wav
├── scenes/
│   ├── main.tscn                # Game orchestrator scene
│   ├── main_menu.tscn           # Title screen and controls overlay
│   ├── player.tscn              # Player CharacterBody2D with camera & weapon
│   ├── bullet.tscn              # Area2D projectile
│   ├── enemies/
│   │   ├── zombie_regular.tscn  # Walker scene
│   │   ├── zombie_fast.tscn     # Runner scene
│   │   └── zombie_tank.tscn     # Brute scene
│   ├── world/
│   │   ├── arena.tscn           # Tiled arena, boundaries, and spawn markers
│   │   ├── obstacle_crate.tscn  # Static cover crate
│   │   └── blood_splatter.tscn  # Particle splatter effect
│   └── ui/
│       ├── hud.tscn             # Health, wave, ammo, and kill stats
│       ├── pause_menu.tscn      # In-game pause modal
│       └── game_over_screen.tscn# Post-match defeat stats & restart
├── scripts/
│   ├── main.gd                  # Core match coordinator
│   ├── player.gd                # Movement, aiming, shooting, health
│   ├── weapon.gd                # Modular firearm base class
│   ├── bullet.gd                # Bullet trajectory & collision
│   ├── base_zombie.gd           # Unified zombie AI, damage & knockback
│   ├── wave_manager.gd          # Wave progression and spawn pacing
│   ├── arena.gd                 # Arena spawn point distribution
│   ├── hud.gd                   # HUD interface controller
│   ├── pause_menu.gd            # Pause overlay controller
│   ├── game_over_screen.gd      # Game over scoreboard controller
│   └── main_menu.gd             # Main menu navigation
└── tests/
    ├── test_runner.gd           # Automated engine test suite
    └── test_runner.tscn         # Headless test runner scene
```
