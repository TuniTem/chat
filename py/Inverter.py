import time
# import threading
import keyboard
import sys
from functools import partial
# import mouse
# from screeninfo import get_monitors
# import pydirectinput

# def get_virtual_bounds():
#     monitors = get_monitors()
#
#     min_x = min(m.x for m in monitors)
#     min_y = min(m.y for m in monitors)
#     max_x = max(m.x + m.width for m in monitors)
#     max_y = max(m.y + m.height for m in monitors)
#
#     return min_x, min_y, max_x, max_y
#
# vmin_x, vmin_y, vmax_x, vmax_y = get_virtual_bounds()

# NUDGE = 4
# MULT = 2

KEY_INVERT = {
    'w': 's',
    's': 'w',
    'a': 'd',
    'd': 'a',

    'up': 'down',
    'down': 'up',
    'left': 'right',
    'right': 'left',
}

held_simulated_keys = set()

running = True

def on_key_event(what : list[str], event):
    if not running:
        return

    name = event.name
    if name not in what:
        return

    inverted = KEY_INVERT[name]

    if event.event_type == "down":
        keyboard.release(name)
        if inverted not in held_simulated_keys:
            keyboard.press(inverted)
            held_simulated_keys.add(inverted)

    elif event.event_type == "up":
        if inverted in held_simulated_keys:
            keyboard.release(inverted)
            held_simulated_keys.remove(inverted)

# last_mouse_pos = mouse.get_position()
#
# def mouse_inversion_loop():
#     global last_mouse_pos, running
#     last_x, last_y = mouse.get_position()
#     while running:
#         x, y = mouse.get_position()
#         pydirectinput.position()
#
#         dx = x - last_x
#         dy = y - last_y
#
#         if dx != 0 or dy != 0:
#             mouse.move(-dx * MULT, -dy * MULT, absolute=False)
#             # pydirectinput.move(dx * MULT, -dy * MULT, relative=True)
#
#         nx, ny = mouse.get_position()
#
#         nudged = False
#
#         if nx <= vmin_x:
#             nx = vmin_x + NUDGE
#             nudged = True
#         elif nx >= vmax_x - 1:
#             nx = vmax_x - NUDGE
#             nudged = True
#
#         if ny <= vmin_y:
#             ny = vmin_y + NUDGE
#             nudged = True
#         elif ny >= vmax_y - 1:
#             ny = vmax_y - NUDGE
#             nudged = True
#
#         if nudged:
#             mouse.move(nx, ny, absolute=True)
#
#         last_x, last_y = mouse.get_position()
#         time.sleep(0.005)


def invert(seconds: float, what : list[str]):
    global running
    running = True

    keyboard.hook(partial(on_key_event, what))

    # m_thread = threading.Thread(target=mouse_inversion_loop, daemon=True)
    # m_thread.start()

    time.sleep(seconds)
    running = False

    for k in list(held_simulated_keys):
        keyboard.release(k)
    held_simulated_keys.clear()

if len(sys.argv) > 1:
    time_inverted : float = float(str(sys.argv[1]))
    keys_inverted : list[str] = str(sys.argv[2]).split(",")
    invert(time_inverted, keys_inverted)