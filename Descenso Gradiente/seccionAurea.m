%%%%%%%%%%%%%%%% algoritmo de sección aurea %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% para el problema multidimensional


function [alpha1]=seccionAurea(f,x0,Fgrad,bk,Max) 
ak=-5;   
tol=0.02;                            % inicio del algoritmo
alpha=0.618;                         % número aureo

lamdak = alpha*ak+(1-alpha)*bk;        % se calcula el valor de lamda
miuk=(1-alpha)*ak+alpha*bk;          % se calcula el valor de miu

x = x0(1,1)+lamdak*Fgrad(1,1);
y = x0(2,1)+lamdak*Fgrad(1,2);
fl = subs(f);                               % se evalua la funcion en lamdak
% fl=f(x0(1,1)+lamdak*Fgrad(1,1),x0(2,1)+lamdak*Fgrad(1,2)); 
%fm=f(x0(1,1)+miuk*Fgrad(1,1),x0(2,1)+miuk*Fgrad(1,2));  
x = x0(1,1)+miuk*Fgrad(1,1);
y = x0(2,1)+miuk*Fgrad(1,2);
fm = subs(f);                               % se evalua la función en miuk
                        

iter=0;                              % se inician las iteraciones
while abs(bk-ak) >= tol              % hacer mientras no se alcance la tolerancia deseada
  iter = iter+1;                     % incrementar el contador de las iteraciones 
  if Max==0
    if fl>fm                         % si la función en lamda es mayor que la función de miu
       ak = lamdak;                  % actualizar el límite ak con lamda
       lamdak = miuk;                % actualizar lamda con el valor antiguo de miu
       fl=fm;                        % actualizar la evaluación de fl con el valor de fm
       miuk=(1-alpha)*ak+alpha*bk;   % definir el nuevo valor de miu
       x = x0(1,1)+miuk*Fgrad(1,1);
       y = x0(2,1)+miuk*Fgrad(1,2);
       fm = subs(f);
       %fm=f(x0(1,1)+miuk*Fgrad(1,1),x0(2,1)+miuk*Fgrad(1,2));                   % evaluar  miu
    elseif fl<fm                     % si la función en miu es mayor que la función de lamda 
       bk=miuk                       % actualizar el límite bk con miu
       miuk=lamdak;                  % actualizar miu con el valor antiguo de lamda
       fm=fl;                        % actualizar la evaluación de fm con el valor de fl
       lamdak=alpha*ak+(1-alpha)*bk; % definir el nuevo valor de lamda
       x = x0(1,1)+lamdak*Fgrad(1,1);
       y = x0(2,1)+lamdak*Fgrad(1,2);
       fl = subs(f);
       %fl=f(x0(1,1)+lamdak*Fgrad(1,1),x0(2,1)+lamdak*Fgrad(1,2));                 % evaluar lamda
    end
  end
  if Max==1
      if fl>fm                         % si la función en lamda es mayor que la función de miu
       bk=miuk
       miuk=lamdak;                  % actualizar miu con el valor antiguo de lamda
       fm=fl;                        % actualizar la evaluación de fm con el valor de fl
       lamdak=alpha*ak+(1-alpha)*bk; % definir el nuevo valor de lamda
       x = x0(1,1)+lamdak*Fgrad(1,1);
       y = x0(2,1)+lamdak*Fgrad(1,2);
       fl = subs(f);
          
    elseif fl<fm                     % si la función en miu es mayor que la función de lamda 
      ak=lamdak;                    % actualizar el límite ak con lamda
       lamdak=miuk;                  % actualizar lamda con el valor antiguo de miu
       fl=fm;                        % actualizar la evaluación de fl con el valor de fm
       miuk=(1-alpha)*ak+alpha*bk;   % definir el nuevo valor de miu
       x = x0(1,1)+miuk*Fgrad(1,1);
       y = x0(2,1)+miuk*Fgrad(1,2);
       fm = subs(f);
    end   
  end
      
    D(iter,:)=[ak lamdak miuk bk]; % registro de los intervalos
%     figure(iter)
%     plot(lamdak,fl,'*b',miuk,fm,'*r')  
%     hold on
    
    
end 
% hold off
alpha1=(lamdak+miuk)/2;
