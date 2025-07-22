% Created by: Nathan Langford
% Last modified: 8th Sept 2006

Hv = [1 0].';
Vv = [0 1].';
Dv = 1/sqrt(2)*(Hv+Vv);
Av = 1/sqrt(2)*(Hv-Vv);
Rv = 1/sqrt(2)*(Hv+1i*Vv);
Lv = 1/sqrt(2)*(Hv-1i*Vv);

Hm = Hv*Hv';
Vm = Vv*Vv';
Dm = Dv*Dv';
Am = Av*Av';
Rm = Rv*Rv';
Lm = Lv*Lv';
