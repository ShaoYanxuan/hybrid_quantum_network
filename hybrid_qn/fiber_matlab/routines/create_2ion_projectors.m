function twoqubitproj=create_2ion_projectors(sing_obs,ions2)



% This program takes as input:
%     -an 1D array of single ion observables (sing_obs)
%     -a 2 element vector specifying two ions 9ions2)
%It spits out a set of 2 qubit projectors for tomo reconstruction of those
%qubits
%
%example arguments:
%sing_obs={XX,ZZ,-ZZ,YY,XX};
%ions2=[1,2];

[noObs,qubits]=size(sing_obs);

twoqubitproj=zeros(4,4,4);

for gg=1:noObs;
    %take first row of sing_obs_array
    row1=sing_obs(gg,:);

        %loop through sing_obs array, build sing_proj array
        for ii=1:length(row1)
            [A,B]=eigs(row1{ii}); %columns of a are e-state vectors
            sing_proj{1,ii}=A(:,1)*A(:,1)';
            sing_proj{2,ii}=A(:,2)*A(:,2)';
        end



        %loop through sing_proj array and build twoqubit_proj array
        %for ions specified in 'ions'

            %build empty projectors variable in form taken by tomo reconsturction
            %(:,:,1) gives first projector
            

            if gg==1;
            mm=1;
            end

            for jj=1:2
                for ii=1:2;
                    twoqubitproj(:,:,mm)=nkron(sing_proj{jj,ions2(1)},sing_proj{ii,ions2(2)});
                    twoqubitproj(:,:,mm);
                    mm = mm+1;
                end
            end

end

twoqubitproj;


% 
% %loop through sing_proj array and build threequbit_proj array
% %for ions specified in 'ions'
% 
%     %build empty projectors variable in form taken by tomo reconsturction
%     %(:,:,1) gives first projector
%     twoqubitproj=zeros(4,4,4);
% 
%     mm=1;
%     for kk=1:2;
%         for jj=1:2
%             for ii=1:2;
%                 threequbitproj(:,:,mm)=nkron(sing_proj{kk,ions3(1)},sing_proj{jj,ions3(2)},sing_proj{ii,ions3(3)});
%                 %twoqubitproj(:,:,mm);
%                 mm = mm+1;
%             end
%         end
%     end
% 
% 
% threequbitproj;

% clear ii jj kk A B mm ans qubits
% 
% whos