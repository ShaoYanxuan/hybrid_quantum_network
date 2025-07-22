% Created by: Nathan Langford
% Last modified: 8th Sept 2006

lv = [1 0 0].';
gv = [0 1 0].';
rv = [0 0 1].';

hv = (rv+lv)/sqrt(2);
vv = (rv-lv)/(i*sqrt(2));
dv = (exp(-i*pi/4)*rv + exp(i*pi/4)*lv)/sqrt(2);
av = (exp(i*pi/4)*rv + exp(-i*pi/4)*lv)/sqrt(2);

lm = lv*lv';
gm = gv*gv';
rm = rv*rv';

hm = hv*hv';
vm = vv*vv';
dm = dv*dv';
am = av*av';
