function y = isnotempty (param, field)
y = 0;
if(isfield(param, field))
    var_name = ['param.' field] ;
     if(length(eval(var_name) )>0)
         y = 1;
     end
end;