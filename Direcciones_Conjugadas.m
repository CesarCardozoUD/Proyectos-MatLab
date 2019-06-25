clc;
syms('z');

Max             = 0;
string_funcion  = input('Digite la función a optimizar: ', 's');
symbs_function  = str2sym(string_funcion);
variables       = symvar(symbs_function);
f               = symbs_function;                           % Función a Optimizar 

X_ini           = input('Digite el valor de X en el vector inicial: ', 's');
Y_ini           = input('Digite el valor de Y en el vector inicial: ', 's');

X0 = [str2double(X_ini) str2double(Y_ini)];

Sx_ini           = input('Digite el valor de X en la dirección inicial: ', 's');
Sy_ini           = input('Digite el valor de Y en la dirección inicial: ', 's');

S0 = [str2double(Sx_ini) str2double(Sy_ini)];

Hessiano        = hessian(f);
x = X0(1);      y = X0(2);
Q               = subs(Hessiano);
Sn              = [ 1 solve(S0*Q*[1;z])];

