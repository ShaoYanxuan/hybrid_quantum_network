# hybrid_quantum_network
Code for the paper [Hybrid satellite-fiber quantum network](https://doi.org/10.1103/s94j-s9n6). 

## Prerequisite

Graph tool is required to view and use the hybrid quantum network. We recommend create a separate new environment using conda/mamba: 

`conda create --name hybrid-qn -c conda-forge graph-tool`

Then activate it: 

`conda activate hybrid-qn`

## Files in `./hybrid_qn`

* `./fiber_matlab/routine/` is downloaded from [https://zenodo.org/records/7781416](https://zenodo.org/records/7781416) to simulate the entanglement swapping.

* The original 2020 census data is downloaded from [https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/](https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/). 

* `./fiber_only/fiber_only.py` generates Figure 2. `./fiber_matlab/fiber_fid_repeater_num.m` calculates the end-to-end fidelity of entanglement created via optical fibers when trapped-ion repeaters are placed along the path, which is saved in `./fiber_only/fidelity_num_repeaters.csv`. 

* Data from 2020 Census to create the network is in `./census_data/coors.csv`, with the coordinates of each census tract. The generated network [Figure 3(a)] is saved in `./optical_fiber.gt.gz`, and `./ground_network/ground_network.py` plots the network. 

* `./fiber_matlab/fiber_time_calculation.m` optimizes the entanglement distribution rate between random Alice and Bob pairs requiring the end-to-end fidelity higher than or equal to 0.87 and saves the data in `./fiber_sat/alice_bob_fiber_rate.csv`.  
`./fiber_sat/satellite.py` calculates the entanglement generation rate via the MEO satellite and saves the results in `./fiber_sat/alice_bob_sat_rate.csv`. Then `./fiber_matlab/fiber_fidelity_calculation.m` optimizes the end-to-end entanglement fidelity between the same Alice and Bob pairs within the time needed to establish one entanglement via the satellite, and saves the data in `./fiber_sat/alice_bob_fiber_fidelity.csv`.
Figure 4 is plotted using `./fiber_sat/fiber_only.py`. 

* `./fiber_matlab/hybrid_rate_calculation.m` optimizes the entanglement distribution rate between end nodes using the hybrid protocol and saves the data in `./hybrid_protocol/alice_bob_hybrid_time_240.csv`. 
`./fiber_matlab/hybrid_fidelity_calculation.m` optimizes the end-to-end entanglement fidelity and saves the data in `./hybrid_protocol/alice_bob_hybrid_fidelity_240.csv`. 
Figure 6 is plotted by `./hybrid_protocol/hybrid.py`. The size of the ground station grid can be changed. 




