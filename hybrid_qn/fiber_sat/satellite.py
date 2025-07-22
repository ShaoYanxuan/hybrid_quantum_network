import numpy as np
import csv
import matplotlib.pyplot as plt
import math
from graph_tool.all import *
import graph_tool.all as gt

def distance(coor1,coor2):
    long1 = coor1[0]; lat1 = coor1[1]
    long2 = coor2[0]; lat2 = coor2[1]
    if lat1==lat2 and long1==long2:
        return 0
    else:
        return (math.acos(math.sin(math.radians(lat1))*math.sin(math.radians(lat2))+\
                     math.cos(math.radians(lat1))*math.cos(math.radians(lat2))*math.cos(math.radians(long2-long1)))*r)
        
def zenith_angle(sat, sta):
    lat = sta[1]/180*np.pi
    long = sta[0]/180*np.pi
    sat_lat = sat[1]/180*np.pi
    sat_long = sat[0]/180*np.pi
    z = np.sqrt(((h+r)*np.cos(sat_lat)*np.cos(sat_long)-r*np.cos(lat)*np.cos(long))**2 + \
                ((h+r)*np.cos(sat_lat)*np.sin(sat_long)-r*np.cos(lat)*np.sin(long))**2 + \
                ((h+r)*np.sin(sat_lat)-r*np.sin(lat))**2)
    cos_theta = (h**2-z**2+2*h*r)/(2*z*r)

def satellite_station_loss(sat, sta):
    lat = sta[1]/180*np.pi
    long = sta[0]/180*np.pi
    sat_lat = sat[1]/180*np.pi
    sat_long = sat[0]/180*np.pi
    z = np.sqrt(((h+r)*np.cos(sat_lat)*np.cos(sat_long)-r*np.cos(lat)*np.cos(long))**2 + \
                ((h+r)*np.cos(sat_lat)*np.sin(sat_long)-r*np.cos(lat)*np.sin(long))**2 + \
                ((h+r)*np.sin(sat_lat)-r*np.sin(lat))**2)
    # z = np.sqrt((r*np.cos(lat)*np.cos(long-sat)-h-r)**2 + (r*np.cos(lat)*np.sin(long-sat))**2 + (r*np.sin(lat))**2)
    wd = w0*np.sqrt(z**2/zR**2)
    eta_diffraction = 2*aR**2/wd**2
    cos_theta = (h**2-z**2+2*h*r)/(2*z*r)
    # cos_theta = ((h+r)**2-z**2+2*(h+r)*r)/(2*z*r)
    eta_atm = np.power(eta_atm0, 1/cos_theta)
    return eta_diffraction*eta_atm*0.5*0.5*0.9*0.9*0.7

with open('../census_data/coors.csv', 'r') as csvfile:
    coors = list(csv.reader(csvfile))[0]
    coors = [[float(item.strip('[').strip(']').split(',')[0]), float(item.strip('[').strip(']').split(',')[1])] for item in coors]
west_most = min([item[0] for item in coors])
east_most = max([item[0] for item in coors])
south_most = min([item[1] for item in coors])
north_most = max([item[1] for item in coors])

with open('../census_data/popu.csv', 'r') as csvfile:
    population = list(csv.reader(csvfile))[0]
    population = [int(item) for item in population]

w0 = 0.15; aR = 0.5; lamb = 8.1e-7
zR = np.pi*w0**2/lamb
h = 10000*1000
r = 6371*1000
eta_atm0 = 0.967
sat = [(west_most+east_most)/2, (south_most+north_most)/2]
print(sat)

g = load_graph('../optical_fiber.gt.gz')
edge_distance = g.new_ep('double')
for e in g.edges():
    edge_distance[e] = distance(coors[int(e.source())], coors[int(e.target())])

with open('../alice_bob_pair.csv', 'r') as csvfile:
    Alice_bob_pairs = [[int(item) for item in item0] for item0 in list(csv.reader(csvfile))]
Alice_bob_distances = []
for item in Alice_bob_pairs:
    Alice_bob_distances.append(distance(coors[item[0]],coors[item[1]])/1e3)
with open('../alice_bob_path.csv', 'r') as csvfile:
    Alice_bob_paths = list(csv.reader(csvfile))
print(len(Alice_bob_pairs), len(Alice_bob_distances), len(Alice_bob_paths))

Sat_rate = [6e7*satellite_station_loss(sat, coors[item[0]])*satellite_station_loss(sat, coors[item[1]]) for item in Alice_bob_pairs]
with open('./alice_bob_sat_rate.csv', 'w') as csvfile:
    csv.writer(csvfile).writerow(Sat_rate)