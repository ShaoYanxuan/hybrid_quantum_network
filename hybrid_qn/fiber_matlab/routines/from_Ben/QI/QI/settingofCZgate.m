clear;
clc;


a=-1.6598;

    


for j=1:6;
    
    theta(j)=(2^(j-1))*a;
    b=mod(theta,-2*pi);
    c=b/pi *45 +45;
    
    
    %c=mod(b,-1*pi);
    %poo(j)=mod((2^(j-1))*a,-2*pi);
    %poop(j)=mod(poo(j),pi)/(2*pi) *  90;
    
%HWP(j)=mod((2^(j-1))*a,-2*pi)/(-2*pi)   *90;

end
c(2)=c(2)+90;
theta
b
c
%poo
%poopa
