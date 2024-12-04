import numpy as np

arr = np.arange(12)

print(arr, type(arr))
print(arr.shape)
arr.shape = 2,6
print(arr)
print(arr[:, 3])

arr = arr.transpose()
print(arr)

with open('floats.txt', 'w') as f:
    f.write('12.12 41.4141 .05 4.4124')

floats = np.loadtxt('floats.txt')
print(floats[-3:])
floats *= .5
np.save('floats', floats)
floats2 = np.load('floats.npy', 'r+')
print(floats2[-3:])
