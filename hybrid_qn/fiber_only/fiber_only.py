import numpy as np
import csv
import matplotlib.pyplot as plt
import math
from graph_tool.all import *
import os
import graph_tool.all as gt
import random
import statistics

def optimal_rate_repeater(l):
    rate_list = []
    for n in range(0,200):
        nu = np.log2(n+1)
        rate_list.append(1/((l/2**nu/c+T0)*np.power(3,nu)/np.power(2,nu-1)/np.power(P0,2)/np.power(10,-gamma*l/(n+1))))
    return max(rate_list), np.argmax(rate_list)

def rate_no_repeater(l):
    return 1/((2*l/c+T0)/(P0*np.power(10,-gamma*l)))

gamma = 0.0173; c = 2e5; T0 = 175e-6; P0 = 0.21;
optimal_rate = []; optimal_number_repeater = []
for l in range(1,1500):
    rate, num_repeater = optimal_rate_repeater(l)
    optimal_rate.append(rate); optimal_number_repeater.append(num_repeater)


fig, ax1 = plt.subplots(figsize=(5,4))
ax2 = ax1.twiny()
ax2.plot(optimal_number_repeater, range(1,1500), color='white', linewidth=0)
ax2.tick_params(axis='x', labelcolor='black')
ax2.xaxis.set_ticks([0,40,80,120,160])
ax1.plot(range(10,100), [1/((2*item/c+T0)/(P0*np.power(10,-gamma*item))) for item in range(10,100)], color='black', linewidth=2)
ax1.plot(range(1,1500), optimal_rate, color='tab:blue', linewidth=2)
ax1.set_xlabel('Alice-Bob fiber length, $L$(km)'); ax1.set_ylabel('Distribution rate, $R_f(s^{-1})$')
plt.yscale('log'); 
plt.ylim(2.6,6.1e2)
ax1.xaxis.set_ticks([0,300,600,900,1200,1500])
plt.xlabel('Optimal number of repeaters, $n_p^*$')
plt.savefig('./2-1.png', dpi=300, bbox_inches = 'tight')


optimal_rate1 = []; optimal_number_repeater1 = []
for l in np.arange(1,120,0.1):
    rate_list = []
    for n in range(0,50):
        nu = np.log2(n+1)
        rate_list.append(1/((l/2**nu/c+T0)*np.power(3,nu)/np.power(2,nu-1)/np.power(P0,2)/np.power(10,-gamma*l/(n+1))))
    optimal_rate1.append(max(rate_list)); optimal_number_repeater1.append(np.argmax(rate_list))
fig, ax1 = plt.subplots(figsize=(3,2.4))
ax2 = ax1.twiny()
ax2.plot(optimal_number_repeater1, np.arange(1,120,0.1), linewidth=0)
# ax2.tick_params(axis='x', labelcolor='black')
ax2.xaxis.set_ticks([0,4,8,12])
ax1.plot(range(10,100), [1/((2*item/c+T0)/(P0*np.power(10,-gamma*item))) for item in range(10,100)], color='black', linewidth=2, label='$R_f^*$')
ax1.plot(np.arange(1,120,0.1), optimal_rate1, color='tab:blue', linewidth=2, label='$R_f$')
plt.yscale('log'); 
plt.ylim(2.6,6.1e2)
ax1.xaxis.set_ticks([0,40,80,120])
ax1.legend(loc=(1.05,0))
plt.savefig('./2-1-1.png', dpi=300, bbox_inches='tight')

T0 = 175e-6; P0 = 0.21; c = 2e5; gamma = 0.0173
l = 300
rate_300 = []
for n in range(0,26):
    nu = np.log2(n+1)
    rate_300.append(1/((l/2**nu/c+T0)*np.power(3,nu)/np.power(2,nu-1)/np.power(P0,2)/np.power(10,-gamma*l/(n+1))))
l = 200
rate_200 = []
for n in range(0,26):
    nu = np.log2(n+1)
    rate_200.append(1/((l/2**nu/c+T0)*np.power(3,nu)/np.power(2,nu-1)/np.power(P0,2)/np.power(10,-gamma*l/(n+1))))
F0 = 0.99; Fphoton = 0.99; Fswap = 0.99;
V = 2*Fphoton-1;
F0 = 1/2*(1+V*(1-2*F0)**2);
# read fidelity data -- calculated by MATLAB
with open('./fidelity_num_repeaters.csv', 'r') as csvfile:
    repeater_fidelity = [float(item) for item in list(csv.reader(csvfile))[0]]
repeater_fidelity.insert(0,F0)
plt.figure(figsize=(5,4))
plt.scatter(range(26), repeater_fidelity, s=30)
plt.plot(range(26),repeater_fidelity)
plt.xlabel('Number of repeaters, $n_p$'); plt.ylabel('Fidelity, $F_f$')
plt.savefig('./2-2.png', dpi=300, bbox_inches='tight')

plt.figure(figsize=(5,4))
plt.plot(range(26), rate_300, color='tab:orange', zorder=1)
plt.scatter(range(26), rate_300, s=35, marker='^', facecolors='white', color='tab:orange', label='L=300 km', zorder=2)
plt.plot(range(26), rate_200, color='tab:orange', zorder=0)
plt.scatter(range(26), rate_200, s=30, facecolors='white', edgecolors='tab:orange', label='L=200 km', zorder=3)
plt.legend(fontsize=14)
plt.yticks([0,3,6,9,12])
plt.xlabel('Number of repeaters, $n_p$'); plt.ylabel('Distribution rate, $R_f (s^{-1})$')
plt.savefig('./2-3.png', dpi=300, bbox_inches='tight')


