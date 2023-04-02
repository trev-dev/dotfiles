#!/usr/bin/env python
import i3ipc

i3 = i3ipc.Connection()


def on_floating_window(i3, e):
    win = i3.get_tree().find_focused()
    print(win.floating)

    if win.floating == 'user_on':
        win.command('border normal')
    elif win.floating == 'user_off':
        win.command('border pixel 1')

    # e.container.command('border normal')


i3.on('window::floating', on_floating_window)

i3.main()
