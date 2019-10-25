#!/usr/bin/env python3

import json
import matplotlib.pyplot as plt

with open('cwnd_log_custom.json') as json_file:
    data = json.load(json_file)
    x = []
    y = []
    for p in data:
        if p['type'] == 'cwnd':
            x.append(p['time'])
            y.append(p['cwnd'])

fig, ax = plt.subplots()
ax.plot(x, y)

ax.set(xlabel='time (us)', ylabel='cwnd (byte)')
ax.grid()

plt.show()

