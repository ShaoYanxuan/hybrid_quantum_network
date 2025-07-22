import numpy as np
import csv
import matplotlib.pyplot as plt
import math

def distance(coor1,coor2):
    long1 = coor1[0]; lat1 = coor1[1]
    long2 = coor2[0]; lat2 = coor2[1]
    if lat1==lat2 and long1==long2:
        return 0
    else:
        return (math.acos(math.sin(math.radians(lat1))*math.sin(math.radians(lat2))+\
                     math.cos(math.radians(lat1))*math.cos(math.radians(lat2))*math.cos(math.radians(long2-long1)))*r)
w0 = 0.15; aR = 0.5; lamb = 8.1e-7
zR = np.pi*w0**2/lamb
h = 10000*1000
r = 6371*1000
eta_atm0 = 0.967

with open('../census_data/coors.csv', 'r') as csvfile:
    coors = list(csv.reader(csvfile))[0]
    coors = [[float(item.strip('[').strip(']').split(',')[0]), float(item.strip('[').strip(']').split(',')[1])] for item in coors]

with open('../alice_bob_pair.csv', 'r') as csvfile:
    Alice_bob_pairs = [[int(item) for item in item0] for item0 in list(csv.reader(csvfile))]
Alice_bob_distances = []
for item in Alice_bob_pairs:
    Alice_bob_distances.append(distance(coors[item[0]],coors[item[1]])/1e3)

with open('../fiber_sat/alice_bob_fiber_rate.csv', 'r') as csvfile:
    fiber_rate = [float(item) for item in list(csv.reader(csvfile))[0]]

with open('../fiber_sat/alice_bob_fiber_fidelity.csv', 'r') as csvfile:
    fiber_fidelity = [float(item) for item in list(csv.reader(csvfile))[0]]

with open('./alice_bob_hybrid_fidelity_240.csv', 'r') as csvfile:
    hybrid_fidelity_240 = [float(item) for item in list(csv.reader(csvfile))[0]]
plt.figure(figsize=(5,3))
protocol_fidelity_240 = []
for i in range(10000):
    if hybrid_fidelity_240[i]>0:
        protocol_fidelity_240.append(max(fiber_fidelity[i],hybrid_fidelity_240[i]))
    else:
        protocol_fidelity_240.append(0)
plt.scatter([Alice_bob_distances[i] for i in range(10000) if protocol_fidelity_240[i]>0], [item for item in protocol_fidelity_240 if item>0.65], s=1)
plt.ylim(0.52,1.02)
plt.xticks([0,1000,2000,3000,4000]); plt.yticks([0.6,0.7,0.8,0.9,1])
plt.xlabel('Alice-Bob distance, $D$ (km)'); plt.ylabel('Fidelity, $F$')
plt.savefig('./6-6.png', dpi=300, bbox_inches="tight")

import statistics
med_240 = statistics.median([item for item in protocol_fidelity_240 if item>0]); print(med_240)
plt.figure(figsize=(2,3))
plt.hist([item for item in protocol_fidelity_240 if item>0], \
         weights=[1/len([item for item in protocol_fidelity_240 if item>0]) for item in [item for item in protocol_fidelity_240 if item>0]],\
         bins=30, range = (min([item for item in protocol_fidelity_240 if item>0]),1), orientation="horizontal")
plt.plot([0,0.2], [med_240,med_240], '--', linewidth=3)
plt.ylim(0.5,1.02); 
plt.yticks([0.6,0.7,0.8,0.9,1.0]); plt.xticks([0,0.1,0.2])
plt.xlabel('Proportion'); plt.ylabel('Fidelity, $F$')
plt.savefig('./6-9.png', dpi=300, bbox_inches="tight")

with open('./hybrid_240_time.csv', 'r') as csvfile:
    hybrid_rate_240 = [1/float(item) for item in list(csv.reader(csvfile))[0]]

plt.figure(figsize=(5,3))
protocol_rate_240 = []
for i in range((len(hybrid_rate_240))):
    if hybrid_rate_240[i]>1e-3:
        protocol_rate_240.append(max(fiber_rate[i],hybrid_rate_240[i]))
    else:
        protocol_rate_240.append(0)
plt.scatter([Alice_bob_distances[i] for i in range(len(protocol_rate_240)) if protocol_rate_240[i]>0], \
            [item for item in protocol_rate_240 if item>0], s=1)
plt.ylim(1e-3,1e3); plt.yscale('log')
plt.xticks([0,1000,2000,3000,4000]); plt.yticks([1e-3,1e-1,1e1,1e3])
plt.xlabel('Alice-Bob distance, $D$ (km)'); plt.ylabel('Rate, $R$ (s$^{-1}$)')
plt.savefig('./6-12.png', dpi=300, bbox_inches="tight")

med_240_rate = statistics.median([item for item in protocol_rate_240 if item>0]); print(med_240_rate)
plt.figure(figsize=(2,3))
logbins = np.logspace(np.log10(1e-3),np.log10(1e3),40)
plt.hist([item for item in protocol_rate_240 if item>0], \
         weights=[1/len([item for item in protocol_rate_240 if item>0]) for item in [item for item in protocol_rate_240 if item>0]] , bins=logbins, range = (5e-5,1e3),\
         orientation="horizontal")
plt.ylim(1e-3,1e3); plt.xlim(0,0.5);plt.xticks([0,0.2,0.4])
plt.plot([0,0.5],[med_240_rate,med_240_rate],'--', linewidth=3)
plt.yscale('log'); plt.xlabel('Proportion'); plt.ylabel('Rate, $R$ (s$^{-1}$)')
plt.savefig('./6-15.png', dpi=300, bbox_inches="tight")


