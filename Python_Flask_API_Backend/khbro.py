# import keyboard as kb
# from pynput import mouse
import win32api
from pynput.keyboard import Key, Controller
import time

isPressed = False
keyboard = Controller()
while True:
    #print(win32con.WM_XBUTTON1)
    a = win32api.GetKeyState(0x0006)
    while (a <-126):
        print('a is pressed')
        time.sleep(0.05)
        if not isPressed:
            keyboard.press(Key.ctrl)
            isPressed = True
        a = win32api.GetKeyState(0x0006)
    
    if isPressed:
        keyboard.release(Key.ctrl)
        isPressed = False