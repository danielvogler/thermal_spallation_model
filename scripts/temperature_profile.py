'''
daniel vogler
'''
from matplotlib import pyplot as mp
import numpy as np
import csv


markerSize = 10.0
lineStyle = 'none'
legendLocation = "upper left"
Color = ['b', 'r', 'm', 'g']
conversionFactor = 1000
fontSize = 15
figuresize = [20, 16]

### temperature
T_max = 1200
T_min = 300.001
T_delta = T_max - T_min
T_initial = 310.002
T_intermediate = 330.003
T_mu = 0.0
T_sigma = 0.007

### times
times = [3.0, 4.0]
y_location = 0.15
x_location = [-0.023, -0.0, 0.0, 0.023]

### number of points
points = 100

### gaussian curve
def gaussian(x, mu, sig):
    return np.exp(-np.power(x - mu, 2.) / (2 * np.power(sig, 2.)))

### gaussian profile between minima and maxima
for mu, sig in [(T_mu, T_sigma) ]:

    temp_initial = (T_initial-T_min)*gaussian(np.linspace(x_location[0], x_location[3], points), mu, sig) + T_min
    temp_intermediate = (T_intermediate-T_min)*gaussian(np.linspace(x_location[0], x_location[3], points), mu, sig) + T_min
    temp_final   = T_delta*gaussian(np.linspace(x_location[0], x_location[3], points), mu, sig) + T_min

    location = np.linspace(x_location[0], x_location[3], points)

    mp.figure(num=None, figsize=(figuresize[0], figuresize[1]), dpi=80, facecolor='w', edgecolor='k')
    mp.plot(location,temp_final, marker='o')
    mp.ylabel('Temperature [K]', fontsize = fontSize)
    mp.xlabel('Location [m]', fontsize = fontSize)
    mp.xlim([x_location[0], x_location[3]])

    mp.figure(num=None, figsize=(figuresize[0], figuresize[1]), dpi=80, facecolor='w', edgecolor='k')
    mp.plot(location,temp_initial, marker='o')
    mp.ylabel('Temperature [K]', fontsize = fontSize)
    mp.xlabel('Location [m]', fontsize = fontSize)
    mp.xlim([x_location[0], x_location[3]])



### write temperature profile to file
fileToSave = str("temperature_profile.txt")
with open(fileToSave, 'w') as csvfile:
    writer = csv.writer(csvfile,delimiter=' ',quoting = csv.QUOTE_NONE,escapechar='\\',quotechar='')
    writer.writerow(['%s' %('AXIS Y')])
    writer.writerow(['%1.4f' %(y_location)])
    writer.writerow(['%s' %('AXIS X')])
    writer.writerow(['{:1.4f}'.format(x) for x in location])
    writer.writerow(['%s' %('AXIS T')])
    writer.writerow(['{:1.4f}'.format(x) for x in times])
    writer.writerow(['%s' %('DATA')])
    writer.writerow([T_min for x in temp_initial])
    #writer.writerow(['{:1.4f}'.format(x) for x in temp_intermediate])
    writer.writerow(['{:1.4f}'.format(x) for x in temp_final])

mp.show()


#temp_right  = T_delta*gaussian(np.linspace(x_location[2], x_location[3], 2*points), mu, sig) + T_min
#temp_nozzle = T_delta*gaussian(np.linspace(x_location[1], x_location[2], 1), mu, 1000000) + T_min
#temp = np.concatenate((temp_left, temp_nozzle, temp_right), axis=0)
#temp = np.concatenate((temp_left, temp_right), axis=0)
