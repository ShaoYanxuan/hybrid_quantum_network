% 23.4.2005
%
% Slightly altered version of iter.m. Allows call as a function with the
% data set as parameter.
%
% Reconstruct a positive semidefinite density matrix from our measurements
% following the strategy outlined
% in Jezek/Fiurasek/Hradil, PRA 68, 012305 (2003)
%whos
% The experimental results are provided in a 2D array where every row
% corresponds to the atomic populations measured after applying a
% transformation that is encoded in the first column.
%
% The reconstructed density matrix is stored in 'rho'.


%edited by Ben Lanyon 31/01/2013 to use list of projectors done, which are
%provided by the user

function [rho, P]=iterfun_data_projectors_tweaked_V(probs,NoI,NoIter,projectors)



%addpath(['..' filesep '..' filesep '..' filesep 'matlab' filesep 'tools'])

%NoI = 4; % number of ions

%path = ['..' filesep '..' filesep '..' filesep '..' filesep 'LinDaten' filesep '20051206' filesep];
%file = 'cprb1714.dat';

%data = readdata(file,1:2^NoI+1);

%data=data1{1};

%[drows,dcols]=size(data);
% 
%probs = data(:,2:dcols);      % columns 2..N contain the measured quantum state probabilities;
% pulsecode = data(:,1);        % column  1 encodes the analysis pulses
% NoExp = length(pulsecode);
% 
% % Decoding of the analysis pulses : Each row of the 2D array pulsecols
% % encodes the transformation applied to the n.th ion:
% % 0 = no pulse applied prior to measurement
% % 1 = pi/2 pulse applied to measure <x>
% % 2 = pi/2 pulse applied to measure <y>
% pulses = double(dec2base(pulsecode,3,NoI))-double('0');
% 
% % The next line replicates each row of pulses 2^NoI times
% pulsetable = reshape(kron(ones(1,2^NoI),pulses)',NoI,NoExp*2^NoI)';

% Now the experimental data are stored in the same way:
%probs = reshape(probs',1,NoExp*2^NoI)';
%[a,b]=size(probs);
%probs = reshape(probs',1,a*b)';

% % For each experimental data point, a measurement of the D state has to be
% % labeled with +1, a measurement of the S-state with 0;
% meas = (double(dec2bin(2^NoI-1:-1:0)')-double('0'))';
% meastable = kron(ones(NoExp,1),meas);
% 
% % Combine 'pulsetable' and 'meastable' to specify the projector on which
% % each ion is projected in the measurement:
% % 1 = projection on - eigenvalue of sigma_z
% % 2 = projection on + eigenvalue of sigma_z
% % 3 = projection on - eigenvalue of sigma_x
% % 4 = projection on + eigenvalue of sigma_x
% % 5 = projection on - eigenvalue of sigma_y
% % 6 = projection on + eigenvalue of sigma_z
% 
% meastable = meastable + 2 * pulsetable + 1;
% Ntable=length(meastable);
% clear pulsetable;
% 
% % Here are the corresponding projectors:
% 
% P(:,:,1) = [0;1]*[0;1]';                % -
% P(:,:,2) = [1;0]*[1;0]';               % +
% P(:,:,3) = [-1;1]*[-1;1]'/2;           % -
% P(:,:,4) = [1;1]*[1;1]'/2;             % +
% P(:,:,5) = [i;1]*[i;1]'/2;             % -
% P(:,:,6) = [-i;1]*[-i;1]'/2;           % +


%------------------------------------------------------------------------
% start iteration with maximally mixed density matrix:
rho = diag(ones(1,2^NoI));
rho = rho/trace(rho);


if isempty('NoIter')
    NoIter = 100;   % number of iterations
end
%tic

%------------------------------------------------------------------------

P = zeros(length(projectors),1);
for j=1:NoIter
    % calculate measurement probabilities for density matrix 'rho'
    ROp = zeros(2^NoI);
%           for k=1:Ntable %e.g. 36 projectors for 2 qubits
            for k=1:length(projectors);

                %Op is the current projector in list of k total
                Op=projectors(:,:,k);

                % Calculate corresponding measurement probability                    
                probOp = trace(rho*Op);
                if(probOp>0)
                    ROp = ROp + probs(k)/probOp * Op;
                end
                %if (j == NoIter)
                    P(k) = probOp;
                %end;
            end
    rho = ROp*rho*ROp;
    rho = rho/trace(rho);

end
%P = (P');
%toc
%------------------------------------------------------------------------

