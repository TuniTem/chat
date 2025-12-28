import time
import threading
from ahk import AHK

ahk = AHK()
running = True
multiplier = 2.0  # mouse delta scaling

# ------------------------
# Keyboard inversion map
# ------------------------
KEY_INVERT = {
    'w': 's', 's': 'w',
    'a': 'd', 'd': 'a',
    'up': 'down', 'down': 'up',
    'left': 'right', 'right': 'left'
}


# ------------------------
# Mouse inversion loop
# ------------------------
last_x, last_y = ahk.get_mouse_position()


def mouse_inversion():
    global last_x, last_y
    while running:
        x, y = ahk.get_mouse_position()
        dx = x - last_x
        dy = y - last_y

        if dx != 0 or dy != 0:
            # Move relative inversely
            ahk.mouse_move(x=-int(dx * multiplier),
                           y=-int(dy * multiplier),
                           speed=0,
                           relative=True)
        last_x, last_y = ahk.get_mouse_position()
        time.sleep(0.1)  # High-frequency polling


# ------------------------
# Start threads
# ------------------------
threading.Thread(target=mouse_inversion, daemon=True).start()

# ------------------------
# Run for a set duration or until Ctrl+C
# ------------------------
try:
    print("Inverting controls. Press Ctrl+C to stop.")
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    running = False
    # Release any held keys
    for k in list(held_keys):
        ahk.key_up(k)
    print("Stopped inversion.")
