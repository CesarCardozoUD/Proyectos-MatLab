clear all
clc

Max=0;
string_funcion = input('Digite la función a optimizar: ', 's');
symbs_function = str2sym(string_funcion);
variables = symvar(symbs_function);
f = symbs_function;
%f=@(x1,x2) (x1-2)^4+(x1-2*x2)^2;                            % Función a Optimizar 
grad = gradient(f,variables)
%grad={@(x1,x2) 4*(x1-2)^3+2*(x1-2*x2),@(x1,x2) -4*x1+8*x2};
  
x0=[0;3];                                                   % Punto inicial debe ser vector columna
Tolerancia =0.09;                                           % Tolerancia del algoritmo
MaxIter=100;                                                % Número de iteraciones máximas
bk=5;                                                       % Límite superior para la búsqueda unidimensional


%% Inicio del algoritmo

x = x0(1); y = x0(2);
Fgrad=[subs(grad(1)), subs(grad(2))];
   
if Max==1
   Fgrad=Fgrad;                        % si se maximiza entonces se escoje el gradiente
else
   Fgrad=-Fgrad;                       % si se minimiza entonces se escoje el menos gradiente 
end
iter=1;

while norm(Fgrad)>=Tolerancia  && iter<=MaxIter                
%    [alpha]=BusquedaDicotomica(f,x0,Fgrad,bk,Max)
%    [alpha]=BusquedaSecuencial(f,x0,Fgrad,bk,Max) 
%    [alpha]=metodoFibonacci(f,x0,Fgrad,bk,Max)
    [alpha] = seccionAurea(f,x0,Fgrad,bk,Max)      % método unidimensional
    D(iter,:)={iter,x0,Fgrad,alpha}
    x0= x0+alpha*Fgrad;                           % se calcula el nuevo punto
    
    x = x0(1,1); y = x0(1,2);
    Fgrad=[subs(grad(1)), subs(grad(2))];
    
    %Fgrad=[grad{1}(x0(1,1),x0(2,1))              % se evalua el gradiente en el punto  
          %grad{2}(x0(1,1),x0(2,1))];
    if Max==1
       Fgrad=Fgrad;                        % si se maximiza entonces se escoje el gradiente
    else
       Fgrad=-Fgrad;                       % si se minimiza entonces se escoje el menos gradiente 
     end
    iter=iter+1;
    D(iter,:)={iter,x0,Fgrad,alpha}
end

% [x1,x2]=meshgrid(-3:0.1:5)
% z=2*x1*x2+2*x2-x1.^2-2*x2.^2
% surf(x1,x2,z)

