clear all
clc
syms('z')

Max             = 0;
string_funcion  = input('Digite la funci�n a optimizar: ', 's');
symbs_function  = str2sym(string_funcion);
variables       = symvar(symbs_function);
f               = symbs_function;                           % Funci�n a Optimizar 
grad            = gradient(f,variables);                    % Vector gradiente de la funci�n

X_ini           = input('Digite el valor de X en el vector inicial: ', 's');
Y_ini           = input('Digite el valor de Y en el vector inicial: ', 's');
  
x0              = [str2sym(X_ini);str2sym(Y_ini)];          % Punto inicial debe ser vector columna
Tolerancia      = 0.09;                                     % Tolerancia del algoritmo
MaxIter         = 10;                                      % N�mero de iteraciones m�ximas
bk              = 5;                                        % L�mite superior para la b�squeda unidimensional


iter            = 1;
do              = true;

while do
    x = x0(1);      y = x0(2);
    Fgrad           = [subs(grad(1)), subs(grad(2))];       % Evaluaci�n de el vector gradiente en el punto inicial
    if Max==1
       Fgrad = Fgrad;                                       % Si se debe maximizar, entonces se evalua el gradiente positivo
    else
       Fgrad = -Fgrad;                                      % Si se debe minimizar, entonces se evalua el gradiente negativo 
    end
    if norm(Fgrad) == 0
        do = false;
    else
        g1 = x0(1) + Fgrad(1)*z;
        g2 = x0(2) + Fgrad(2)*z;
        x = g1; y = g2;
        
        f_sub = subs(f);
        [alpha] = solve(diff(f_sub), z);
        S = transpose(x0) + ([alpha]*Fgrad);
        x0 = S;
    end
end

x = double(x0(1));
y = double(x0(2));
z = double(subs(f));
disp([' ----------------- Soluci�n ----------------- ']);
disp([' Punto Optimo:']); 
disp(['   X = ', num2str(x)]);
disp(['   Y = ', num2str(y)]);
disp([' Valor de la funci�n F.O en el punto: Z = ', num2str(z)]);
