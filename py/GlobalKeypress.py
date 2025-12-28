import time

import keyboard
import mouse
import sys

if len(sys.argv) > 1:
    input_button = str(sys.argv[1])
    if input_button.startswith("mouse"):
        match input_button:
            case "mouse_left":
                mouse.click(button="left")
            case "mouse_right":
                mouse.click(button="right")
            case "mouse_middle":
                mouse.click(button="middle")
            case "mouse_wheel_up":
                mouse.wheel(delta=1)
            case "mouse_wheel_down":
                mouse.wheel(delta=-1)
            case "mouse_button_4":
                mouse.click(button="x")
            case "mouse_button_5":
                mouse.click(button="x2")

    else:
        keyboard.press(input_button)
        time.sleep(0.1)
        keyboard.release(input_button)