close all
%Frame 0 CFP
%Frame 1 CFP_dark
%Frame 2 YFP
%Frame 3 YFP_dark

i=0; % 0 Se trabaja con CFP, 2 Se trabaja con YFP

%r=getrangefromclass(uint16(2));

%Exp='05.01.16';  % 19 Pos, 112 Step
%Exp='06.01.16'; % 23 Pos (24 esta vacia), 199 Step
%Exp='07.01.16'; % 23 Pos, 138 Step
%Exp='09.01.16'; % 19 Pos, 241 Step
%Exp='10.01.16'; % 19 Pos, 287 Step
%Exp='12.01.16'; % 23 Pos, 153 Step
%Exp='13.01.16'; % 25 Pos, 233 Step

Exp=['05.01.16';'06.01.16';'07.01.16';'09.01.16';'10.01.16';'12.01.16';'13.01.16'];
Pos=[19;23;23;19;19;23;25];
Step=[112;199;138;241;287;153;233];


guardar=1;
video=1;
visualizar=0;

for m=3:7
if video
   mkdir(strcat(Exp(m,:),'_Videos'));
end
if guardar
    mkdir(strcat(Exp(m,:),'_Segmentacion'));
end


for j=0:Pos(m) %Cantidad de Posiciones
    
    umbral=400;umbral_aux1=1000;umbral_aux2=2000;umbral_aux3=3000; % Brillo de célula única sin dark. Experimento 05.01.16,  06.01.16,  07.01.16,  09.01.16,  10.01.16,  12.01.16,  13.01.16
    
    
Area_1=0;
%Brillo=zeros(100,1);
if video
    movie = avifile(strcat(Exp(m,:),'_Videos\video_P',sprintf('%02d',j),'_Frame_CFP','.avi'), 'fps', 5, 'compression', 'none');
end
if guardar
    mkdir(strcat(Exp(m,:),'_Segmentacion\Pos00',sprintf('%02d',j)));
    ruta_fin=strcat(Exp(m,:),'_Segmentacion\Pos00',sprintf('%02d',j));
end

for n=0:Step(m) %Cantidad de Step
    
ruta1=strcat(Exp(m,:),'\Pos00',sprintf('%02d',j),'\Frame00',sprintf('%02d',i),'Step0',sprintf('%03d',n),'.tiff');
ruta2=strcat(Exp(m,:),'\Pos00',sprintf('%02d',j),'\Frame00',sprintf('%02d',i+1),'Step0',sprintf('%03d',n),'.tiff');
CFP=imread(ruta1);
CFP_dark=imread(ruta2);
CFP_S=CFP-CFP_dark;

%Cambio de umbral
if umbral==400
    if max(CFP_S(:))>25000
        if sum(CFP_S(:)>25000)>Area_1*5
            umbral=umbral_aux1;
        end
    end
elseif umbral==umbral_aux1   
    if max(CFP_S(:))>50000
        if sum(CFP_S(:)>50000)>Area_1*10
            umbral=umbral_aux2;
        end
    end
elseif umbral==umbral_aux2   
    if max(CFP_S(:))>60000
        if sum(CFP_S(:)>60000)>Area_1*15
            umbral=umbral_aux3;
        end
    end
end


%figure;imshow(YFP_S,[])
g=fspecial('gaussian',[20 20],2); % Crea un filtro gaussiano , para atenuar los rapidos cambios de frecuencia
%g=fspecial('average',[100 100]);
O=(imfilter(CFP_S,g));
%figure;imshow(O,[])


%close all
%level=graythresh(O);
% [levels]=multithresh(O,2);
% 
BW=(O>umbral);
%figure;imshow(BW,[])
%  figure;subplot(1,3,1);imshow(double(YFP).*BW,[]);title('original')
%  subplot(1,3,2);imshow(BW);subplot(1,3,3);imshow(YFP_S,[])
 %figure;subplot(1,2,1);imshow(YFP_S,[]);
 %  subplot(1,2,2);imshow(BW,[]);



% 
% Eliminar los puntos blancos pequeños
if Area_1==0
 CC = bwconncomp(BW, 8);
 %Compute the area of each component:
 S = regionprops(CC, 'Area');
%Remove small objects:
L = labelmatrix(CC);
l=sort([S.Area],'descend');
try
    Area_1=l(1);
    BW1 = ismember(L, find([S.Area] >= l(1)/2.5));
catch
    BW1=BW;
end
%figure;imshow(BW1);title('BW')
else
BW1=bwareaopen(BW,round(Area_1/2.5),8); %Elimina los pedazos exteriores que pueden haber quedado luego de la binarización
%BW1=ismember(L, find([S.Area] >= 1.1*Area(1)));
end

%Eliminar los puntos negros pequeños
CC = bwconncomp(~BW1, 8);
 %Compute the area of each component:
 S = regionprops(CC, 'Area');
%Remove small objects:
L = labelmatrix(CC);
%l=sort([S.Area],'descend');
BW2 = ~ismember(L, find([S.Area] >= Area_1));

% Visualizar
if n~=0 && visualizar
 figure;subplot(1,3,1);imshow(CFP_S,[]);title('original')
  subplot(1,3,2);imshow(BW2);title(umbral)
  subplot(1,3,3);imshow(mat2gray(CFP_S).*BW2);title('Seg')
end



% Perim=bwperim(BW2,8);
% Imvideo=zeros(size(YFP_S,1),size(YFP_S,2),3);
% Imvideo(:,:,1)=uint8(mat2gray(YFP_S)*255);
% Imvideo(:,:,2)=uint8(mat2gray(YFP_S)*255);
% Imvideo(:,:,3)=uint8(mat2gray(YFP_S)*255);
% Imvideo(:,:,1)=uint8(Perim)+Imvideo(:,:,1);
% figure;imshow(Imvideo)
% %Formar el video
%BW3=bwboundaries(BW2);
%figure;imshow(BW2)


if video
    movie = addframe(movie, BW2*255);
end
% 
if guardar
imwrite(BW2,strcat(ruta_fin,'\Frame_CFP','Step0',sprintf('%03d',n),'_S.tiff'))
end



end

if video   
    movie=close(movie);
end


end
end