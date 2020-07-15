from pynput import keyboard, mouse
from threading import Thread
import time
loop = False


def on_activate_h():
    global loop
    print('<ctrl>+<alt>+h pressed', loop)
    if loop:
        loop = False
    else:
        loop = True


def on_activate_i():
    print('<ctrl>+<alt>+i pressed')


h = keyboard.GlobalHotKeys({
        '<ctrl>+<alt>+h': on_activate_h,
        '<ctrl>+<alt>+i': on_activate_i})
h.start()
ms = mouse.Controller()
if __name__ == '__main__':
    while True:
        if loop:
            print('in loop')
            ms.press(mouse.Button.left)
            time.sleep(0.0100)
            ms.release(mouse.Button.left)
            time.sleep(1)
        # print('out of loop')
        time.sleep(0.01)