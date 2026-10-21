import wave
import struct
import math
import random
import os

AUDIO_DIR = r"C:\Users\Pranav Mathur\.gemini\antigravity-ide\scratch\zombie_survival_godot\assets\audio"
SAMPLE_RATE = 22050

def save_wav(filename, samples):
    filepath = os.path.join(AUDIO_DIR, filename)
    with wave.open(filepath, "w") as f:
        f.setnchannels(1) # mono
        f.setsampwidth(2) # 16-bit
        f.setframerate(SAMPLE_RATE)
        packed = []
        for s in samples:
            val = int(max(-32767, min(32767, s * 32767)))
            packed.append(struct.pack("<h", val))
        f.writeframes(b"".join(packed))

def create_shoot():
    # Punchy gunshot with quick pitch drop and white noise burst
    duration = 0.18
    num_samples = int(duration * SAMPLE_RATE)
    samples = []
    phase = 0.0
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        env = math.exp(-t * 28.0)
        # Pitch drops rapidly from 450Hz to 60Hz
        freq = 450.0 * math.exp(-t * 35.0) + 60.0
        phase += 2.0 * math.pi * freq / SAMPLE_RATE
        sine = math.sin(phase)
        noise = (random.random() * 2.0 - 1.0)
        # mix noise & sine
        sample = (0.5 * sine + 0.5 * noise) * env
        samples.append(sample)
    save_wav("shoot.wav", samples)

def create_hit():
    # Squishy flesh impact
    duration = 0.12
    num_samples = int(duration * SAMPLE_RATE)
    samples = []
    phase = 0.0
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        env = math.exp(-t * 32.0)
        freq = 280.0 * math.exp(-t * 40.0) + 70.0
        phase += 2.0 * math.pi * freq / SAMPLE_RATE
        noise = (random.random() * 2.0 - 1.0) * 0.3
        sample = (math.sin(phase) + noise) * env * 0.8
        samples.append(sample)
    save_wav("hit.wav", samples)

def create_zombie_die():
    # Groan + splat on defeat
    duration = 0.35
    num_samples = int(duration * SAMPLE_RATE)
    samples = []
    phase = 0.0
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        env = math.exp(-t * 8.0)
        # Low rumbling downward glide
        freq = 160.0 * (1.0 - t / duration * 0.7)
        phase += 2.0 * math.pi * freq / SAMPLE_RATE
        noise = (random.random() * 2.0 - 1.0) * 0.4
        sample = (math.sin(phase) * 0.6 + noise * 0.4) * env
        samples.append(sample)
    save_wav("zombie_die.wav", samples)

def create_player_hurt():
    # Impact grunt
    duration = 0.22
    num_samples = int(duration * SAMPLE_RATE)
    samples = []
    phase = 0.0
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        env = math.exp(-t * 14.0)
        freq = 220.0 * math.exp(-t * 15.0) + 80.0
        phase += 2.0 * math.pi * freq / SAMPLE_RATE
        sample = math.sin(phase) * env
        samples.append(sample)
    save_wav("player_hurt.wav", samples)

def create_reload():
    # Mechanical click-clack
    duration = 0.4
    num_samples = int(duration * SAMPLE_RATE)
    samples = [0.0] * num_samples
    
    # Click 1 at 0.05s
    idx1 = int(0.05 * SAMPLE_RATE)
    for j in range(int(0.06 * SAMPLE_RATE)):
        t = j / SAMPLE_RATE
        env = math.exp(-t * 70.0)
        val = math.sin(2.0 * math.pi * 1200.0 * t) * env * 0.8
        if idx1 + j < num_samples:
            samples[idx1 + j] += val
            
    # Click 2 at 0.25s
    idx2 = int(0.25 * SAMPLE_RATE)
    for j in range(int(0.08 * SAMPLE_RATE)):
        t = j / SAMPLE_RATE
        env = math.exp(-t * 60.0)
        val = math.sin(2.0 * math.pi * 1600.0 * t) * env * 0.9
        if idx2 + j < num_samples:
            samples[idx2 + j] += val
            
    save_wav("reload.wav", samples)

def create_wave_start():
    # Rising alert chime
    duration = 0.6
    num_samples = int(duration * SAMPLE_RATE)
    samples = []
    phase = 0.0
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        env = min(1.0, t * 15.0) * (1.0 - t / duration)
        freq = 300.0 + (t / duration) * 450.0
        phase += 2.0 * math.pi * freq / SAMPLE_RATE
        sample = (math.sin(phase) + 0.3 * math.sin(phase * 2.0)) * env * 0.7
        samples.append(sample)
    save_wav("wave_start.wav", samples)

def create_game_over():
    # Descending gloomy tone
    duration = 1.0
    num_samples = int(duration * SAMPLE_RATE)
    samples = []
    phase = 0.0
    for i in range(num_samples):
        t = i / SAMPLE_RATE
        env = math.exp(-t * 2.5)
        freq = 350.0 * math.exp(-t * 1.5) + 50.0
        phase += 2.0 * math.pi * freq / SAMPLE_RATE
        sample = (math.sin(phase) + 0.4 * math.sin(phase * 0.5)) * env * 0.8
        samples.append(sample)
    save_wav("game_over.wav", samples)

if __name__ == "__main__":
    create_shoot()
    create_hit()
    create_zombie_die()
    create_player_hurt()
    create_reload()
    create_wave_start()
    create_game_over()
    print("All audio files generated successfully!")
