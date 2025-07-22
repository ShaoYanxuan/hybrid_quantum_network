import numpy as np
import csv
import matplotlib.pyplot as plt
import math
from graph_tool.all import *
import os
import graph_tool.all as gt
import random
import statistics

def distance(coor1,coor2):
    long1 = coor1[0]; lat1 = coor1[1]
    long2 = coor2[0]; lat2 = coor2[1]
    if lat1==lat2 and long1==long2:
        return 0
    else:
        return (math.acos(math.sin(math.radians(lat1))*math.sin(math.radians(lat2))+\
                     math.cos(math.radians(lat1))*math.cos(math.radians(lat2))*math.cos(math.radians(long2-long1)))*r)

r = 6371*1000

with open('../census_data/coors.csv', 'r') as csvfile:
    coors = list(csv.reader(csvfile))[0]
    coors = [[float(item.strip('[').strip(']').split(',')[0]), float(item.strip('[').strip(']').split(',')[1])] for item in coors]

with open('../census_data/popu.csv', 'r') as csvfile:
    population = list(csv.reader(csvfile))[0]
    population = [int(item) for item in population]

g = load_graph('../optical_fiber.gt.gz')
edge_distance = g.new_ep('double')
for e in g.edges():
    edge_distance[e] = distance(coors[int(e.source())], coors[int(e.target())])
    

plt.figure(figsize=(10,5))
plt.scatter([item[0] for item in coors], [item[1] for item in coors], s=0.1)
for e in g.edges():
    if edge_distance[e]<61.7*1e3:
        plt.plot([coors[int(e.source())][0],coors[int(e.target())][0]],[coors[int(e.source())][1],coors[int(e.target())][1]], color='tab:blue', linewidth=0.3)
    else:
        plt.plot([coors[int(e.source())][0],coors[int(e.target())][0]],[coors[int(e.source())][1],coors[int(e.target())][1]], color='tab:green', linewidth=1)
plt.xlabel('Longitude (W)'); plt.ylabel('Latitude (N)')
plt.savefig('./ground_network.png', dpi = 300, bbox_inches = 'tight')

