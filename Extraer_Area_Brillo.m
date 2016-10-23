%Frame 0 CFP
%Frame 1 CFP_dark
%Frame 2 YFP
%Frame 3 YFP_dark

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

for m=2:7
mkdir(strcat(Exp(m,:),'_Resultados'));



for j=0:Pos(m) % Cantidad de Pos
Area=zeros(Step(m)+1,1);
Brillo_YFP=zeros(Step(m)+1,1);
Brillo_YFP_dark=zeros(Step(m)+1,1);
Brillo_CFP=zeros(Step(m)+1,1);
Brillo_CFP_dark=zeros(Step(m)+1,1);

for n=0:Step(m) %Cantidad de Step
    
ruta_0=strcat(Exp(m,:),'\Pos00',sprintf('%02d',j),'\Frame00',sprintf('%02d',0),'Step0',sprintf('%03d',n),'.tiff');
ruta_1=strcat(Exp(m,:),'\Pos00',sprintf('%02d',j),'\Frame00',sprintf('%02d',1),'Step0',sprintf('%03d',n),'.tiff');
ruta_2=strcat(Exp(m,:),'\Pos00',sprintf('%02d',j),'\Frame00',sprintf('%02d',2),'Step0',sprintf('%03d',n),'.tiff');
ruta_3=strcat(Exp(m,:),'\Pos00',sprintf('%02d',j),'\Frame00',sprintf('%02d',3),'Step0',sprintf('%03d',n),'.tiff');
ruta_S=strcat(Exp(m,:),'_Segmentacion\Pos00',sprintf('%02d',j),'\Frame_CFP','Step0',sprintf('%03d',n),'_S.tiff');

YFP=imread(ruta_2);
YFP_dark=imread(ruta_3);
CFP=imread(ruta_0);
CFP_dark=imread(ruta_1);
Segmentation=imread(ruta_S);

YFP_E=YFP-YFP_dark; % YFP substract dark
CFP_E=CFP-CFP_dark; % CFP substract dark

Area(n+1)=sum(Segmentation(:));

YFP_S=double(YFP).*Segmentation;
YFP_E_S=double(YFP_E).*Segmentation;
CFP_S=double(CFP).*Segmentation;
CFP_E_S=double(CFP_E).*Segmentation;

Brillo_YFP(n+1)=sum(YFP_S(:));
Brillo_YFP_dark(n+1)=sum(YFP_E_S(:));

Brillo_CFP(n+1)=sum(CFP_S(:));
Brillo_CFP_dark(n+1)=sum(CFP_E_S(:));





end
ruta_fin=strcat(Exp(m,:),'_Resultados\Pos00',sprintf('%02d',j));
save(ruta_fin,'Area','Brillo_YFP','Brillo_YFP_dark','Brillo_CFP','Brillo_CFP_dark');

end
end