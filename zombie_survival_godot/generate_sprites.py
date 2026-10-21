import math
from PIL import Image, ImageDraw

SPRITES_DIR = r"C:\Users\Pranav Mathur\.gemini\antigravity-ide\scratch\zombie_survival_godot\assets\sprites"

def create_player():
    size = (32, 32)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    
    # Player facing right (East)
    # Shoulders / Torso
    d.ellipse([10, 8, 22, 24], fill=(45, 60, 75, 255), outline=(25, 35, 45, 255))
    # Tactical vest
    d.rectangle([11, 10, 20, 22], fill=(65, 85, 100, 255))
    d.line([(15, 10), (15, 22)], fill=(35, 45, 55, 255), width=1)
    
    # Left Arm
    d.rectangle([17, 8, 24, 12], fill=(45, 60, 75, 255))
    d.rectangle([24, 9, 27, 12], fill=(225, 175, 120, 255)) # Left hand
    
    # Right Arm & Gun
    d.rectangle([17, 20, 24, 24], fill=(45, 60, 75, 255))
    d.rectangle([24, 20, 27, 23], fill=(225, 175, 120, 255)) # Right hand
    
    # Pistol held forward
    d.rectangle([25, 14, 31, 18], fill=(60, 64, 70, 255))
    d.rectangle([27, 15, 31, 17], fill=(120, 125, 135, 255))
    # Gun barrel tip
    d.point([(31, 16)], fill=(180, 185, 195, 255))
    
    # Head & Cap (facing right)
    d.ellipse([9, 10, 21, 22], fill=(225, 175, 120, 255), outline=(180, 130, 90, 255))
    # Cap / Helmet
    d.pieslice([8, 9, 22, 23], 120, 300, fill=(35, 45, 55, 255))
    d.rectangle([16, 12, 23, 15], fill=(30, 40, 50, 255)) # Cap brim pointing right
    # Goggles / Eyes
    d.line([(19, 14), (19, 18)], fill=(40, 180, 220, 255), width=2)
    
    img.save(f"{SPRITES_DIR}\\player.png")

def create_zombie_regular():
    size = (32, 32)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    
    # Zombie facing right
    # Torso (tattered shirt)
    d.ellipse([9, 8, 21, 24], fill=(70, 85, 65, 255), outline=(40, 50, 35, 255))
    d.rectangle([10, 11, 19, 21], fill=(110, 50, 45, 255)) # torn reddish shirt
    d.point([(14, 15), (17, 18), (12, 19)], fill=(40, 50, 35, 255)) # holes showing green decay
    
    # Outstretched claw arms reaching right
    d.rectangle([16, 6, 25, 10], fill=(70, 100, 65, 255))
    d.polygon([(25, 6), (29, 7), (29, 9), (25, 10)], fill=(90, 125, 80, 255))
    d.point([(29, 7), (29, 9)], fill=(200, 220, 180, 255)) # claw nails
    
    d.rectangle([16, 22, 25, 26], fill=(70, 100, 65, 255))
    d.polygon([(25, 22), (29, 23), (29, 25), (25, 26)], fill=(90, 125, 80, 255))
    d.point([(29, 23), (29, 25)], fill=(200, 220, 180, 255))
    
    # Head (rotting green flesh)
    d.ellipse([8, 10, 20, 22], fill=(95, 130, 85, 255), outline=(50, 75, 45, 255))
    # Decayed patches
    d.point([(10, 12), (11, 12), (10, 13)], fill=(50, 35, 25, 255))
    # Glowing yellow-green eyes
    d.point([(17, 13), (17, 18)], fill=(220, 255, 80, 255))
    d.point([(18, 13), (18, 18)], fill=(120, 200, 40, 255))
    # Snarl / Teeth
    d.line([(19, 15), (19, 17)], fill=(200, 200, 160, 255))
    
    img.save(f"{SPRITES_DIR}\\zombie_regular.png")

def create_zombie_fast():
    size = (28, 28)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    
    # Fast runner zombie - leaner, crimson-toned, fierce
    # Torso
    d.ellipse([7, 8, 17, 20], fill=(130, 60, 55, 255), outline=(80, 30, 30, 255))
    
    # Slender forward reaching arms
    d.line([(14, 7), (25, 5)], fill=(145, 75, 70, 255), width=2)
    d.point([(25, 4), (26, 5), (25, 6)], fill=(240, 200, 200, 255))
    d.line([(14, 21), (25, 23)], fill=(145, 75, 70, 255), width=2)
    d.point([(25, 22), (26, 23), (25, 24)], fill=(240, 200, 200, 255))
    
    # Head
    d.ellipse([6, 9, 16, 19], fill=(160, 80, 75, 255), outline=(100, 40, 40, 255))
    # Glowing blood-red eyes
    d.point([(14, 11), (14, 17)], fill=(255, 30, 30, 255))
    d.point([(15, 11), (15, 17)], fill=(255, 180, 180, 255))
    # Jagged mouth
    d.line([(16, 13), (16, 15)], fill=(240, 220, 220, 255))
    
    img.save(f"{SPRITES_DIR}\\zombie_fast.png")

def create_zombie_tank():
    size = (44, 44)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    
    # Huge hulking brute
    # Massive shoulders
    d.ellipse([10, 8, 30, 36], fill=(70, 65, 85, 255), outline=(40, 35, 55, 255))
    d.rectangle([14, 12, 28, 32], fill=(55, 50, 70, 255))
    # Metal plates / straps
    d.line([(12, 16), (28, 28)], fill=(130, 135, 150, 255), width=2)
    d.line([(12, 28), (28, 16)], fill=(130, 135, 150, 255), width=2)
    
    # Giant fists reaching forward
    d.ellipse([26, 6, 38, 16], fill=(85, 75, 100, 255), outline=(50, 45, 65, 255))
    d.ellipse([26, 28, 38, 38], fill=(85, 75, 100, 255), outline=(50, 45, 65, 255))
    # Spikes on fists
    d.polygon([(38, 10), (42, 11), (38, 12)], fill=(180, 185, 200, 255))
    d.polygon([(38, 32), (42, 33), (38, 34)], fill=(180, 185, 200, 255))
    
    # Head (embedded between shoulders)
    d.ellipse([12, 14, 26, 30], fill=(95, 85, 110, 255), outline=(55, 45, 70, 255))
    # Furious glowing eyes
    d.point([(23, 19), (23, 25)], fill=(255, 190, 40, 255))
    d.point([(24, 19), (24, 25)], fill=(255, 255, 180, 255))
    # Underbite jaw
    d.rectangle([23, 21, 26, 24], fill=(210, 215, 220, 255))
    
    img.save(f"{SPRITES_DIR}\\zombie_tank.png")

def create_bullet():
    size = (14, 6)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Bright glowing tracer bullet pointing right
    d.rectangle([0, 2, 7, 3], fill=(255, 120, 20, 180)) # trail
    d.rounded_rectangle([3, 1, 13, 4], radius=2, fill=(255, 220, 50, 255)) # core
    d.line([(7, 2), (13, 2)], fill=(255, 255, 240, 255)) # hot white highlight
    d.line([(7, 3), (13, 3)], fill=(255, 255, 240, 255))
    img.save(f"{SPRITES_DIR}\\bullet.png")

def create_floor_tile():
    size = (64, 64)
    img = Image.new("RGBA", size, (32, 35, 42, 255))
    d = ImageDraw.Draw(img)
    # Concrete slab with bevel border and subtle grid
    d.rectangle([0, 0, 63, 63], outline=(22, 24, 30, 255), width=1)
    d.rectangle([2, 2, 61, 61], outline=(40, 44, 52, 255), width=1)
    
    # Subtle metal rivets in corners
    for cx in (5, 58):
        for cy in (5, 58):
            d.point([(cx, cy)], fill=(60, 65, 75, 255))
            d.point([(cx+1, cy)], fill=(20, 22, 26, 255))
            
    # Light grit & subtle scratch
    d.line([(18, 22), (28, 25)], fill=(38, 42, 50, 255))
    d.line([(42, 45), (46, 52)], fill=(26, 28, 34, 255))
    d.line([(12, 48), (20, 50)], fill=(26, 28, 34, 255))
    img.save(f"{SPRITES_DIR}\\floor_tile.png")

def create_wall_tile():
    size = (64, 64)
    img = Image.new("RGBA", size, (24, 26, 32, 255))
    d = ImageDraw.Draw(img)
    
    # Reinforced dark metal block
    d.rectangle([0, 0, 63, 63], outline=(12, 13, 16, 255), width=2)
    d.rectangle([3, 3, 60, 60], fill=(36, 40, 48, 255), outline=(50, 55, 66, 255), width=1)
    
    # Industrial hazard warning stripes on top portion
    for i in range(-20, 80, 16):
        d.polygon([(i+6, 4), (i+14, 4), (i+4, 14), (i-4, 14)], fill=(210, 105, 30, 200))
        
    # Reinforced center plate
    d.rectangle([8, 18, 55, 55], fill=(28, 31, 38, 255), outline=(18, 20, 24, 255), width=2)
    # Metal bolts
    for bx in (12, 51):
        for by in (22, 51):
            d.rectangle([bx, by, bx+2, by+2], fill=(120, 130, 145, 255))
    
    img.save(f"{SPRITES_DIR}\\wall_tile.png")

def create_crate():
    size = (48, 48)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    
    # Outer wood body
    d.rectangle([2, 2, 45, 45], fill=(115, 78, 48, 255), outline=(55, 36, 20, 255), width=2)
    d.rectangle([6, 6, 41, 41], fill=(138, 95, 60, 255))
    
    # Diagonal brace bars
    d.line([(6, 6), (41, 41)], fill=(95, 65, 40, 255), width=4)
    d.line([(6, 41), (41, 6)], fill=(95, 65, 40, 255), width=4)
    
    # Metal corner brackets
    corners = [(2, 2), (37, 2), (2, 37), (37, 37)]
    for cx, cy in corners:
        d.rectangle([cx, cy, cx+8, cy+8], fill=(70, 75, 85, 255), outline=(40, 45, 50, 255), width=1)
        d.point([(cx+4, cy+4)], fill=(180, 190, 200, 255)) # rivet
        
    img.save(f"{SPRITES_DIR}\\crate.png")

def create_blood_particle():
    size = (8, 8)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([1, 1, 6, 6], fill=(180, 20, 20, 240))
    d.point([(3, 3)], fill=(230, 40, 40, 255))
    img.save(f"{SPRITES_DIR}\\blood_particle.png")

def create_muzzle_flash():
    size = (16, 16)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Bright starburst
    d.polygon([(8, 0), (10, 6), (16, 8), (10, 10), (8, 16), (6, 10), (0, 8), (6, 6)], fill=(255, 200, 50, 240))
    d.polygon([(8, 3), (9, 7), (13, 8), (9, 9), (8, 13), (7, 9), (3, 8), (7, 7)], fill=(255, 255, 240, 255))
    img.save(f"{SPRITES_DIR}\\muzzle_flash.png")

def create_crosshair():
    size = (24, 24)
    img = Image.new("RGBA", size, (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    # Center dot
    d.point([(11, 11), (12, 11), (11, 12), (12, 12)], fill=(255, 60, 60, 255))
    # 4 reticle brackets
    d.line([(11, 2), (11, 7)], fill=(255, 60, 60, 255), width=2)
    d.line([(11, 16), (11, 21)], fill=(255, 60, 60, 255), width=2)
    d.line([(2, 11), (7, 11)], fill=(255, 60, 60, 255), width=2)
    d.line([(16, 11), (21, 11)], fill=(255, 60, 60, 255), width=2)
    img.save(f"{SPRITES_DIR}\\crosshair.png")

if __name__ == "__main__":
    create_player()
    create_zombie_regular()
    create_zombie_fast()
    create_zombie_tank()
    create_bullet()
    create_floor_tile()
    create_wall_tile()
    create_crate()
    create_blood_particle()
    create_muzzle_flash()
    create_crosshair()
    print("All sprites successfully generated!")
