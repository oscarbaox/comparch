import numpy as np

x = np.array(range(512))
y = list(np.round(511 * 0.5 * (1. + np.sin(2. * np.pi * x / 512.))))
y = [int(v) for v in y]

f = open('sine.txt', 'w')
for v in y:
    f.write(f'{v}\n')
f.close()
