warning off all
close all
% Ver http://www.mathworks.com/help/curvefit/smoothing-data.html
%     http://www.mathworks.com/help/curvefit/smooth.html#zmw57dd0e44393

%Exp='05.01.16';  %19 Pos, 112 Step
%Exp='06.01.16'; % 23 Pos (24 esta vacia), 199 Step
%Exp='07.01.16'; % 23 Pos, 138 Step
%Exp='09.01.16'; % 19 Pos, 241 Step
%Exp='10.01.16'; % 19 Pos, 287 Step
%Exp='12.01.16'; % 23 Pos, 153 Step
%Exp='13.01.16'; % 25 Pos, 233 Step

Exp=['05.01.16';'06.01.16';'07.01.16';'09.01.16';'10.01.16';'12.01.16';'13.01.16'];
Pos=[19;23;23;19;19;23;25];
Step=[112;199;138;241;287;153;233];

save_data=0;
save_plot=0;
visualizar=1;

for m=1:7
if save_data || save_plot
    mkdir(strcat(Exp(m,:),'_Resultados\Smooth'));
    
end

x=1:Step(m)+1;

for j=0:Pos(m)
ruta_datos=strcat(Exp(m,:),'_Resultados\Pos00',sprintf('%02d',j));
Datos=load(ruta_datos);

f=fittype('poly9');

% Función filtro
X1=Datos.Area;
Y1=Filtro_simple(X1);
Area=smooth(Y1,'moving');
p=polyfit(transp(x),Area,9);
f_Area=cfit(f,p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10));

X2=Datos.Brillo_CFP;
Y2=Filtro_simple(X2);
Brillo_CFP=smooth(Y2,'moving');
p=polyfit(transp(x),Brillo_CFP,9);
f_Brillo_CFP=cfit(f,p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10));

X3=Datos.Brillo_CFP_dark;
Y3=Filtro_simple(X3);
Brillo_CFP_dark=smooth(Y3,'moving');
p=polyfit(transp(x),Brillo_CFP_dark,9);
f_Brillo_CFP_dark=cfit(f,p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10));

X4=Datos.Brillo_YFP;
Y4=Filtro_simple(X4);
Brillo_YFP=smooth(Y4,'moving');
p=polyfit(transp(x),Brillo_YFP,9);
f_Brillo_YFP=cfit(f,p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10));

X5=Datos.Brillo_YFP_dark;
Y5=Filtro_simple(X5);
Brillo_YFP_dark=smooth(Y5,'moving');
p=polyfit(transp(x),Brillo_YFP_dark,9);
f_Brillo_YFP_dark=cfit(f,p(1),p(2),p(3),p(4),p(5),p(6),p(7),p(8),p(9),p(10));


if visualizar
%figure;plot(Datos.Brillo_YFP_dark);title(ruta_datos)

figure;title(ruta_datos);subplot(1,2,1);plot(x,X1,'-b',x,f_Area(x),':r','LineWidth',3);title(ruta_datos)
limsy=get(gca,'YLim');
set(gca,'YLim',[0 limsy(2)]);
set(gca,'XLim',[0 Step(m)+1]);
xlabel('Step')
ylabel('BrilloCFP')
legend('Curva orignal','Curva ajustada')
%hold on
D=diff(X1);
D=[D;D(end)];
subplot(1,2,2);plot(x,D,'-b',x,differentiate(f_Area,transp(x)),':r','LineWidth',3);title(ruta_datos)
limsy=get(gca,'YLim');
set(gca,'YLim',[0 limsy(2)]);
set(gca,'XLim',[0 Step(m)+1]);
xlabel('Step')
ylabel('BrilloCFP')
legend('Derivada Curva orignal','Derivada Curva ajustada')
end

% figure;subplot(1,4,1);plot(Datos.Area)
% subplot(1,4,2);plot(Datos.Brillo_YFP_dark)
% subplot(1,4,3);plot(Datos.Area,Datos.Brillo_YFP_dark)
% 
% subplot(1,4,4);plot(Datos.Brillo_YFP_dark./Datos.Area)
if save_data
    ruta_fin=strcat(Exp(m,:),'_Resultados\Smooth\Pos00',sprintf('%02d',j));
    save(ruta_fin,'f_Area','f_Brillo_YFP','f_Brillo_YFP_dark','f_Brillo_CFP','f_Brillo_CFP_dark');
end
if save_plot
    mkdir(strcat(Exp(m,:),'_Resultados\Smooth\Plot'));
    ruta_fin=strcat(Exp(m,:),'_Resultados\Smooth\Plot\Pos00',sprintf('%02d',j));
   % Area
    L = figure('visible', 'off');
    subplot(1,2,1);plot(x,X1,'-b',x,f_Area(x),'.r','LineWidth',3,'MarkerSize',10);title('Curva')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('Area')
    legend('Curva orignal','Curva ajustada')
    D=diff(X1);
    D=[D;D(end)];
    subplot(1,2,2);plot(x,D,'-b',x,differentiate(f_Area,transp(x)),'.r','LineWidth',3,'MarkerSize',10);title('Derivate')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('Area')
    legend('Curva orignal','Curva ajustada')
    print(strcat(ruta_fin,'Area'),'-dtiff')
    close(L)
    
    % Brillo_CFP
    L = figure('visible', 'off');
    subplot(1,2,1);plot(x,X2,'-b',x,f_Brillo_CFP(x),'.r','LineWidth',3,'MarkerSize',10);title('Curva')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('BrilloCFP')
    legend('Curva orignal','Curva ajustada')
    D=diff(X2);
    D=[D;D(end)];
    subplot(1,2,2);plot(x,D,'-b',x,differentiate(f_Brillo_CFP,transp(x)),'.r','LineWidth',3,'MarkerSize',10);title('Derivate')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('BrilloCFP')
    legend('Curva orignal','Curva ajustada')
    print(strcat(ruta_fin,'Brillo_CFP'),'-dtiff')
    close(L)
    
    % Brillo_CFP_dark
    L = figure('visible', 'off');
    subplot(1,2,1);plot(x,X3,'-b',x,f_Brillo_CFP_dark(x),'.r','LineWidth',3,'MarkerSize',10);title('Curva')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('BrilloCFPdark')
    legend('Curva orignal','Curva ajustada')
    D=diff(X3);
    D=[D;D(end)];
    subplot(1,2,2);plot(x,D,'-b',x,differentiate(f_Brillo_CFP_dark,transp(x)),'.r','LineWidth',3,'MarkerSize',10);title('Derivate')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('BrilloCFPdark')
    legend('Curva orignal','Curva ajustada')
    print(strcat(ruta_fin,'Brillo_CFP_dark'),'-dtiff')
    close(L)
    
    % Brillo_YFP
    L = figure('visible', 'off');
    subplot(1,2,1);plot(x,X4,'-b',x,f_Brillo_YFP(x),'.r','LineWidth',3,'MarkerSize',10);title('Curva')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('BrilloYFP')
    legend('Curva orignal','Curva ajustada')
    D=diff(X4);
    D=[D;D(end)];
    subplot(1,2,2);plot(x,D,'-b',x,differentiate(f_Brillo_YFP,transp(x)),'.r','LineWidth',3,'MarkerSize',10);title('Derivate')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('BrilloYFP')
    legend('Curva orignal','Curva ajustada')
    print(strcat(ruta_fin,'Brillo_YFP'),'-dtiff')
    close(L)
    % Brillo_YFP_dark
    L = figure('visible', 'off');
    title(ruta_datos);subplot(1,2,1);plot(x,X5,'-b',x,f_Brillo_YFP_dark(x),'.r','LineWidth',3,'MarkerSize',10);title('Curva')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('BrilloYFPdark')
    legend('Curva orignal','Curva ajustada')
    D=diff(X5);
    D=[D;D(end)];
    subplot(1,2,2);plot(x,D,'-b',x,differentiate(f_Brillo_YFP_dark,transp(x)),'.r','LineWidth',3,'MarkerSize',10);title('Derivate')
    limsy=get(gca,'YLim');
    set(gca,'YLim',[0 limsy(2)]);
    set(gca,'XLim',[0 Step(m)+1]);
    xlabel('Step')
    ylabel('BrilloYFPdark')
    legend('Curva orignal','Curva ajustada')
    print(strcat(ruta_fin,'Brillo_YFP_dark'),'-dtiff')
    close(L)
end
% title (j)
end
end