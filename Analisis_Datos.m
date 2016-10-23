close all
for j=0:19
ruta_datos=strcat('05.01.16_Resultados\Pos00',sprintf('%02d',j));
Datos=load(ruta_datos);
%figure;plot(Datos.Brillo_YFP_dark,Datos.Brillo_YFP);
figure;subplot(1,4,1);plot(Datos.Area)
subplot(1,4,2);plot(Datos.Brillo_YFP_dark)
subplot(1,4,3);plot(Datos.Area,Datos.Brillo_YFP_dark)

subplot(1,4,4);plot(Datos.Brillo_YFP_dark./Datos.Area)
limsy=get(gca,'YLim');
set(gca,'YLim',[0 limsy(2)]);
% title (j)
end