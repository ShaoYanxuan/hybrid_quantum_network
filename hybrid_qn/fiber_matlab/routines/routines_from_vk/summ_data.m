function out = summ_data(in1, in2) 
out = in1;
 for hh=1:length(out.tomo_matrix1)
   % out.Allclicks{hh}= in1.Allclicks{hh}+in2.Allclicks{hh};
    %out.Allcounts{hh}=in1.Allcounts{hh}+in2.Allcounts{hh};
   % out.Allgoodcounts{hh}=in1.Allgoodcounts{hh}+in2.Allgoodcounts{hh};
   % out.Allstrange{hh}=in1.Allstrange{hh}+in2.Allstrange{hh};
   % out.attemptsbases{hh}=in1.attemptsbases{hh}+in2.attemptsbases{hh};
    out.tomo_matrix1{hh}=0.5*(in1.tomo_matrix1{hh}+in2.tomo_matrix1{hh});

    out.tomo_matrix1_counts{hh}=in1.tomo_matrix1_counts{hh}+in2.tomo_matrix1_counts{hh};
    %out.tomo_matrix1_cum{hh}=0.5*(in1.tomo_matrix1_cum{hh}+in2.tomo_matrix1_cum{hh});

   % out.tomo_matrix1_counts_cum{hh}=in1.tomo_matrix1_counts_cum{hh}+in2.tomo_matrix1_counts_cum{hh};
%      out.wavepacketx{hh}=in1.wavepacketx{hh}+in2.wavepacketx{hh};
%     out.wavepackety{hh}=in1.wavepackety{hh}+in2.wavepackety{hh};
end;
out.tomo_matrix_attempts1{1}=in1.tomo_matrix_attempts1{1}+in2.tomo_matrix_attempts1{1};
   