
%% Agradecimientos a Stephen Cobeldick por sus sugerencias %%
%%

clc;
% Ventana para definir la función objetivo ===========================================
prompt  = {'Función objetivo = ', 'max == 1 or min==2','Numero de restricciones = '};
lineno  = 1;
title   = 'Ingreso de Datos';
def     = {'[ ]','0','0'};
options.Resize = 'on';

C = inputdlg(prompt,title,lineno,def,options);
[m,n]   = size(C);
cout    = str2num(C{1});          %Se transforman los valores (cadena de caracteres) ingresados en la FO a un vector de enteros
type    = str2double(C{2});       %Se transforman los valores (cadena de caracteres) ingresados en el tipo de FO a un entero
num_restr     = str2double(C{3});       %Se transforman los valores (cadena de caracteres) ingresados en el numero de restricciones a un entero

str1    = struct('vari',{},'Type',{});
str2    = struct('var_base',{},'valor',{});
% ====================================================================================


% Ventana para definir restricciones ==========================================
for i=1:num_restr %Se definen los tipos de restricciones en orden
    prompt          = {strcat('Ingrese el tipo de restricción para la condición ',num2str(i),' (<=,>=,=):')};
    title           = 'Ingreso de Datos';
    def             = {''};
    options.Resize  = 'on';
    p               = inputdlg(prompt,title,lineno,def,options);
    str1(1,i).Type  = sscanf(p{1}, '%c');
end
% ====================================================================================


% Ventana para definir coeficinetes de las restricciones =============================
prompt          = {'Ingrese la matriz de restricciones'};
lineno          = 1;
title           = 'Ingreso de Datos';
def             = {'[]'};
options.Resize  ='on';
t               = inputdlg(prompt,title,lineno,def,options);
sc              = str2num(t{1}); %Se transforman los valores (cadena de caracteres) ingresados en el campo, a un matriz de enteros
% ====================================================================================


% Ventana para definir coeficinetes de 'b' ==========================================
prompt          = {'Ingrese el vector de valores independientes b'};
lineno          = 1;
title           = 'Ingreso de Datos';
def             = {'[]'};
options.Resize  = 'on';
u               = inputdlg(prompt,title,lineno,def,options);
second          = str2num(u{1});
% ====================================================================================

M               = 1000*max(max(sc)); % Penalización para el algoritmo "GRAN M"
sc1             = []; %Matriz de Variables de holgura
sc2             = []; %Matriz de Variables artificiales
v_a             = zeros(1,length(cout));
var_exceso      = [];
v_b             = [];
v_ari           = [];
j               = 1;


%Paso a forma estandar
for i=1:num_restr 
    n = str1(1,i).Type;
    if n(1)~= '<' && isempty(sc2)
        sc2     = zeros(num_restr,1);
    end
    switch str1(1,i).Type
        case '<=' 
            var_exceso                 = [var_exceso second(i)];
            sc1(j,length(var_exceso))  = 1;
            v_b                 = [v_b second(i)];
            
        case '>='
            var_exceso                  = [var_exceso 0];
            sc1(j,length(var_exceso))   = -1;
            v_ari                       = [v_ari second(i)];
            sc2(j,length(v_ari))= 1;
            v_b                 = [v_b second(i)];
              
        case'=' 
            v_ari               = [v_ari second(i)];
            sc2(j,length(v_ari))= 1;
            sc1(j,length(v_ari))= 0;
            v_b                 = [v_b,second(i)];
              
    end
    j = j+1;
end
%=======================================


sc      = [sc,sc1,sc2]; %Nueva Matriz de restricciones con variables artificiales y de holgura añadidas
vari    = [];
vari_a  = [];
vari_e  = [];
vari_ar = [];


for i=1:size(sc,2)
    str1(1,i).vari  = ['x',num2str(i)];
    vari            = [vari,str1(1,i).vari,' '];
    if i<length(v_a)
        vari_a      = [vari_a,str1(1,i).vari,' '];
    elseif i<=length(v_a)+length(var_exceso)
        vari_e      = [vari_e,str1(1,i).vari,' '];
    else
        vari_ar     = [vari_ar,str1(1,i).vari,' '];
    end
end


% Primera iteración
x=[v_a,var_exceso,v_ari];
if isempty(v_ari)
    v_ar    = ones(1,length(v_ari));
    if type==1
        v_ar=-M*length(v_ari).*v_ar;
    else
       v_ar=M*length(v_ari).*v_ar;
    end
else
    v_ar =[];
end

Cj      = [cout,0.*var_exceso,v_ar];
Vb      = [];
Q       = v_b;
Ci      = [];
tabl    = [];

for i=1:length(Q)
    tabl                = [tabl; ' | '];
    str2(1,i).valeur    = Q(i);
    ind                 = find(x==Q(i));
    str2(1,i).var_base  = str1(1,ind).vari;
    Vb                  = [Vb,str2(1,i).var_base,' '];
    Ci                  = [Ci,Cj(ind)];
end

Z  = sum(Ci.*Q);

for i=1:length(Cj)
    Zj(i)               =   sum(Ci'.*sc(:,i));
end

Cj_Zj   = Cj-Zj;
l       = [];
for i=1:num_restr
    if length(str2(1,i).var_base)==2
        l=[l;str2(1,i).var_base,' '];
    else
         l=[l;str2(1,i).var_base];
    end
end


fprintf('\n');
disp('======================== Problema en forma estandar ========================');
disp(['Variables : ',vari]);
disp(['                   -Variables No Básicas     : ',vari_a]);
disp(['                   -Variables Básicas        : ',vari_e]);
disp(['                   -Variables Artificiales   : ',vari_ar]);
disp('============================================================================');
disp(' ');
disp('===============================   Tableau 0  ===============================');
disp(['Inicialización de variables : ',vari]);
disp(['                   -Variables No Básicas     : ',num2str(v_a)]);
disp(['                   -Variables Básicas        : ',num2str(var_exceso)]);
disp(['                   -Variables Artificiales   : ',num2str(v_ar)]);
disp('============================================================================');
disp(' ');
disp(['Cj                  : ',num2str(Cj)]);
disp('_______________________________________________________________________');
disp([tabl,num2str(Ci'),tabl,l,tabl,num2str(Q'),tabl,num2str(sc),tabl]);
disp('_______________________________________________________________________');
disp(['Zj                  : ',num2str(Zj)]); 
disp(['Cj-Zj                  : ',num2str(Cj-Zj)]);        
disp(['Z                  : ',num2str(Z)]);  
disp('_______________________________________________________________________');
disp(' ');

%Iteraciones de Simplex Gran M
t       = 1;
arret   = 1;
while arret==1
    if type==1
        num=max(Cj_Zj);num=num(1);
        num1=find(Cj_Zj==num);num1=num1(1);
        V_ent=str1(1,num1).vari;
    else
      g=min(Cj_Zj);g=g(1);
        num1=find(Cj_Zj==g);num1=num1(1);
        V_ent=str1(1,num1).vari;                
        ['x',num2str(num1)];
    end
    b=sc(:,num1);
    k=0;d=10000;
    for i=1:length(Q)
        if b(i)>0
            div=Q(i)/b(i);
            if d>div
                d=div;
                k=i;
            end
        end
    end
    if k~=0
        num2=k;
    else
        disp('No se puede encontrar solución : La solución es infactible ');
        break;
    end
    V_sort=str2(1,num2).var_base;
    str2(1,num2).var_base=str1(1,num1).vari;
    pivot=sc(num2,num1);
    Ci(num2)=Cj(num1);
    sc(num2,:)=sc(num2,:)./pivot;
    Q(num2)=Q(num2)/pivot;
    h=size(sc,1);
    for i=1:h
        if i~=num2
            Q(i)=Q(i)-sc(i,num1)*Q(num2);
            sc(i,:)=sc(i,:)-sc(i,num1).*sc(num2,:);
            
        end
    end
    Z=sum(Ci.*Q);
    for i=1:size(sc,2)
        Zj(i)=sum(Ci'.*sc(:,i));
    end
    Cj_Zj=Cj-Zj;
    l=[];V=[];
    for i=1:num_restr
        if length(str2(1,i).var_base)==2
            l=[l;str2(1,i).var_base,' '];
            V=[V,l(i,:),' '];
        else
          l=[l;str2(1,i).var_base];
          V=[V,l(i,:),' '];
        end
    end
Vb      = V;
disp(['===============================   Tableau ',num2str(t),' ===============================']);
disp(['Variable de entrada  : ',num2str(V_ent)]);
disp(['Variable de salida   : ',num2str(V_sort)]);
disp(['Pivote               : ',num2str(pivot)]);
disp(['Variables Básicas    : ',num2str(Vb)]);
disp('============================================================================');
disp(' ');
disp(['Cj                   : ',num2str(Cj)]);
disp('_______________________________________________________________________');
disp([tabl,num2str(Ci'),tabl,l,tabl,num2str(Q'),tabl,num2str(sc),tabl]);
disp('_______________________________________________________________________');
disp(['Zj                  : ',num2str(Zj)]); 
disp(['Cj-Zj                  : ',num2str(Cj-Zj)]);        
disp(['Z                  : ',num2str(Z)]);  
disp('_______________________________________________________________________');
disp(' ');
disp(' ');
t       = t+1;
if type==1
    a=max(Cj_Zj);a=a(1);
    if a<=0
        break;
    end
else
a   = min(Cj_Zj);a=a(1); 
if a>=0 
    break;
end
end
end
p   = num2str(Z);
k   = msgbox( p,'RESULTADO F.O. OPTIMO :');