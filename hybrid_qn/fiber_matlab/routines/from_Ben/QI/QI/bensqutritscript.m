standardbiphoton





    for x=1:10000;
  Uparam= [pi/2*(rand(6,1))];
   A =exp(i*Uparam(3))*HWPbp(Uparam(5))*HWPbp(Uparam(1))*fockfilter(Uparam(6))*HWPbp(Uparam(2))*HWPbp(Uparam(4))*bp20m;
   A=A/norm(A);
   plot3(real(A(1)),real(A(2)),real(A(3)),'.b');
   hold on;
    end

hold off


%HWP = 
%[exp(i*2*n),0,0;0,exp(i*m)*exp(i*n),0;0,0,exp(2*i*m)]