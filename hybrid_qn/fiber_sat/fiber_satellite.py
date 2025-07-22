import csv
import matplotlib.pyplot as plt

with open('./alice_bob_sat_rate.csv', 'r') as csvfile:
    sat_rate = [float(item) for item in list(csv.reader(csvfile))[0]]
with open('../alice_bob_distance.csv', 'r') as csvfile:
    Alice_bob_distances = [float(item) for item in list(csv.reader(csvfile))[0]]
with open('./alice_bob_fiber_rate.csv', 'r') as csvfile:
    fiber_rate = [float(item) for item in list(csv.reader(csvfile))[0]]
fiber_rate = [item if item>1e-6 else 0 for item in fiber_rate]

print(len(fiber_rate))

plt.figure(figsize=(5,4))
plt.scatter([Alice_bob_distances[i] for i in range(10000) if fiber_rate[i]>1e-6], [item for item in fiber_rate if item>1e-6], s=1, zorder=1); 
plt.scatter(Alice_bob_distances, sat_rate, s=1, zorder=2)
# for i in range(2000):
#     plt.plot([Alice_bob_distances[i],Alice_bob_distances[i]], [sat_rate_lower[i],sat_rate_upper[i]], color='grey',zorder=0)

plt.yscale('log'); plt.xlim(-50,2500)
plt.xlabel('Alice-Bob distance, $D$ (km)'); plt.ylabel('Distribution rate, $R$ ($s^{-1}$)')
plt.savefig('./4-1.png', dpi=300, bbox_inches='tight')


with open('./alice_bob_fiber_fidelity.csv', 'r') as csvfile:
    fiber_fidelity = [float(item) for item in list(csv.reader(csvfile))[0]]
print(len(fiber_fidelity))
plt.figure(figsize=(5,4))
plt.scatter([Alice_bob_distances[i] for i in range(10000) if fiber_fidelity[i]>0], [item for item in fiber_fidelity if item>0], s=1)
plt.plot([0,1350], [0.87,0.87], color='tab:orange', linewidth=2)
plt.xticks([0,300,600,900,1200]); 
plt.xlabel('Alice-Bob distance, $D$ (km)'); plt.ylabel('Fidelity, $F$')
plt.savefig('./4-2.png', dpi=300, bbox_inches='tight')


fig, ax1 = plt.subplots(figsize=(5.8,4))
ax1.scatter([item for item in fiber_fidelity[:5000] if item>0], \
            [fiber_rate[i] for i in range(5000) if fiber_fidelity[i]>0], s=1, color='purple')
plt.yscale('log'); plt.ylabel('Distribution rate, $R$ ($s^{-1}$)', color='purple')
ax1.tick_params(axis='y', labelcolor='purple')

ax2 = ax1.twinx()  # instantiate a second Axes that shares the same x-axis
ax2.yaxis.set_ticks([0,0.02,0.04,0.06]); 
ax2.set_ylabel('Proportion', color='grey')
ax2.tick_params(axis='y', colors='grey')
alice_bob_fiber_fidelity_mod = [item for item in fiber_fidelity if item>0]
ax2.hist(alice_bob_fiber_fidelity_mod, weights = [1/len(alice_bob_fiber_fidelity_mod) for item in alice_bob_fiber_fidelity_mod], bins=30, color='grey', alpha=0.5)
fig.tight_layout()  # otherwise the right y-label is slightly clipped
plt.savefig('./4-3.png', dpi=300, bbox_inches='tight')