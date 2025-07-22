function rhomc = statetomMCX(data, Nqubits, cycles, Niter, N, ps)
%global ps
%statetomMCX - State Tomography from data and Monte Carlo simulations
%
% This function produces desitiy matricies through state tomography 
% from Monte Carlo simulations around a given data set.
%
% Syntax:  rhomc = statetomMCX(data, Nqubits, cycles, Niter, N,
% rhofile, save)
%
% Inputs   :
%   cycles  -  measurement cycles per setting (corresponding to exp data!)
%   Niter   -  number of process tomography iterations
%   N       -  number of MC samples
%   rhofile -  output filename
%
% Output:
%    rhomc  - Monte Carlo simulated rho matricies from state tomography
%
%
% Other m-files required: proctom.m
% Subfunctions: none
% MAT-files required: none
%
% Authors: Cornelius Hempel
% Blatt Group
% email: 
% Website: http://www.quantumoptics.at
% March 2011; Last revision: 11-March-2011

%% ------------- BEGIN CODE --------------



    rhomc = zeros(2^Nqubits, 2^Nqubits, N+1);
    disp('Process tomography of original data: ');
%    tic
        %rhoout{yy,vv}=iterfun_data_projectors_tweaked(cprb,length(ions),100,ps); 
        rhomc(:,:,N+1) = iterfun_data_projectors_tweaked(data,Nqubits,Niter,ps);
        rhomc(:,:,N+1) = rhomc(:,:,N+1)/trace(rhomc(:,:,N+1)); 
%    toc
    tic

 
        for a = 1:N   % allow for parallel execution
              
              disp(['MC sample #' num2str(a) ' of ' num2str(N) ...
                  ' | ' num2str(cycles) ' cycles' ...
                  ' | ' num2str(Niter) ' iterations']);
              
              % reserve memory of appropriate size
              % in here and not outside of loop due to parfor execution
              % has to be classifiable by each parallel process
              dataMC = zeros(size(data(:,2:end)));
              probs = zeros(size(data(:,2:end),2));
              datafixed = zeros(size(data(1,2:end)));

              
              
              % address zero Eigenvalue problem by replacing with 1 and
              % renormalizing, read Audenaert paper for more
              
              % going through each row
              for b = 1:size(data,1)
                  datafixed = data(b,2:end)*cycles; % get # of occurences
                  indi=find(datafixed==0);          % find '0' entries
                  datafixed(indi) = 1;              % set those to '1'
                  cyclesfixed = sum(datafixed);     % renormalize
                  probs = datafixed/cyclesfixed;    % back to probabilities

                  % generate 'cycles' samples from multinomial
                  % distribution based on probs
                  % -> result is integer, therefore again convert to probs
                  % by division of the underlying cycles of the input prob
                  dataMC(b,:) = mnrnd(cycles, probs)/cyclesfixed;
              end

            % replaces all the NaN in case the original contains zeros,
            % which it should not
            %dataMC(isnan(dataMC)) = 0;
 
            % the actual tomography of the data set
            rhomc(:,:,a) = iterfun_data_projectors_tweaked([data(:,1) dataMC], Nqubits, Niter,ps);
            
            %iterfun_data_projectors_tweaked(data,Nqubits,Niter,ps);
            
        end 
    duration = toc;
        
%     %% log how long this MC session took
%     fid = fopen('performance.txt', 'a');
%     logentry = sprintf('%s-MC-c%s-i%s-m%s.mat -- %s s',rhofile,num2str(cycles),num2str(Niter),num2str(N),num2str(duration));
%     fprintf(fid,'%s\n', logentry);
%     fclose(fid);