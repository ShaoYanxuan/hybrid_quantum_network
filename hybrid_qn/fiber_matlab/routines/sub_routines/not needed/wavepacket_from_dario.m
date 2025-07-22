function WP = wavepacket_from_dario(dt, histlength, fname)
%dt =0.5
%histlength = 150;

bin_arr = 0.01*dt:dt:histlength;
Input= load(fname)/2/pi;
figure(21)
photon1 = histogram(Input(:, 1), bin_arr);
figure(22)
photon1 = histogram(Input(:, 2), bin_arr);
WP(:,1 ) = bin_arr(1:length(bin_arr)-1);
WP(:,2) =photon1.Values+photon1.Values;
close(21,22)
            