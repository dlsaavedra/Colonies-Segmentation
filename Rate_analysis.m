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

save_data=1;
save_plot=1;

for m=1:7
    
    x=transp(1:Step(m)+1);
    
    mkdir(strcat(Exp(m,:),'_Resultados\Rate_Analysis'));

    for j=0:Pos(m)
        ruta_datos=strcat(Exp(m,:),'_Resultados\Smooth\Pos00',sprintf('%02d',j));
        Datos=load(ruta_datos); 
        %Data(1) es de la Pos0000
        Data(j+1).f_Area=Datos.f_Area;
        Data(j+1).f_Brillo_CFP=Datos.f_Brillo_CFP;
        Data(j+1).f_Brillo_CFP_dark=Datos.f_Brillo_CFP_dark;
        Data(j+1).f_Brillo_YFP=Datos.f_Brillo_YFP;
        Data(j+1).f_Brillo_YFP_dark=Datos.f_Brillo_YFP_dark;
        % Observacion se le agrega el último elemento al vector diff, para que
        % conserve el largo y es alfinal ya que solo nos importa la derivada
        % por la derecha
    %     U=diff(Data(j+1).Area);
    %     Data(j+1).U=[U;U(end)]./Data(j+1).Area;
    %     Kc=diff(Data(j+1).Brillo_CFP);
    %     Data(j+1).Kc=[Kc;Kc(end)]./Data(j+1).Area;
    %     Ky=diff(Data(j+1).Brillo_YFP);
    %     Data(j+1).Ky=[Ky;Ky(end)]./Data(j+1).Area;
    %     
        Data(j+1).U=differentiate(Data(j+1).f_Area,x)./Data(j+1).f_Area(x);
        Data(j+1).Kc=differentiate(Data(j+1).f_Brillo_CFP,x)./Data(j+1).f_Area(x);
        Data(j+1).Ky=differentiate(Data(j+1).f_Brillo_YFP,x)./Data(j+1).f_Area(x);

        if save_plot
            
            f = figure('visible', 'off');
    %         x=t y=U
            subplot(2,3,1);
            plot(x,Data(j+1).U);title(strcat(Exp(m,:),'Pos00',sprintf('%02d',j)))
            limsy=get(gca,'YLim');
            limsx=get(gca,'XLim');
            set(gca,'YLim',[0 limsy(2)]);
            set(gca,'XLim',[0 limsx(2)]);
            xlabel('Step')
            ylabel('U (growth rate)')


        %     x=t y=Ky
            subplot(2,3,2);
            plot(x,Data(j+1).Ky);title(strcat(Exp(m,:),'Pos00',sprintf('%02d',j)))
            limsy=get(gca,'YLim');
            limsx=get(gca,'XLim');
            set(gca,'YLim',[0 limsy(2)]);
            set(gca,'XLim',[0 limsx(2)]);
            xlabel('Step')
            ylabel('Ky (sintetize rate)')


        %     x=t y=Kc
            subplot(2,3,3);
            plot(x,Data(j+1).Kc);title(strcat(Exp(m,:),'Pos00',sprintf('%02d',j)))
            limsy=get(gca,'YLim');
            limsx=get(gca,'XLim');
            set(gca,'YLim',[0 limsy(2)]);
            set(gca,'XLim',[0 limsx(2)]);
            xlabel('Step')
            ylabel('Kc (sintetize rate)')


            %Se elimina el 5% inicial y final, error en aproximación.
            U=Data(j+1).U(round(length(Data(j+1).U)/20):round(length(Data(j+1).U)*19/20));
            Ky=Data(j+1).Ky(round(length(Data(j+1).Ky)/20):round(length(Data(j+1).Ky)*19/20));
            Kc=Data(j+1).Kc(round(length(Data(j+1).Kc)/20):round(length(Data(j+1).Kc)*19/20));
            
        %    x=U y=Ky    
            subplot(2,3,4);
            plot(U,Ky,'.b');title(strcat(Exp(m,:),'Pos00',sprintf('%02d',j)))
            limsy=get(gca,'YLim');
            limsx=get(gca,'XLim');
            set(gca,'YLim',[limsy(1) limsy(2)]);
            set(gca,'XLim',[limsx(1) limsx(2)]);
            xlabel('U (growth rate)')
            ylabel('Ky (sintetize rate)')


            % x=U y=Kc
            subplot(2,3,5);
            plot(U,Kc,'.b');title(strcat(Exp(m,:),'Pos00',sprintf('%02d',j)))
            limsy=get(gca,'YLim');
            limsx=get(gca,'XLim');
            set(gca,'YLim',[limsy(1) limsy(2)]);
            set(gca,'XLim',[limsx(1) limsx(2)]);
            xlabel('U (growth rate)')
            ylabel('Kc (sintetize rate)')

            % x=Ky y=Kc
            subplot(2,3,6);
            plot(Ky,Kc,'.b');title(strcat(Exp(m,:),'Pos00',sprintf('%02d',j)))
            limsy=get(gca,'YLim');
            limsx=get(gca,'XLim');
            set(gca,'YLim',[limsy(1) limsy(2)]);
            set(gca,'XLim',[limsx(1) limsx(2)]);
            xlabel('Ky (sintetize rate)')
            ylabel('Kc (sintetize rate)')

            print(strcat(Exp(m,:),'_Resultados\Rate_Analysis\','Pos00',sprintf('%02d',j)),'-dtiff')
            close(f)
        end
    end

    
    if save_data
        ruta_fin=strcat(Exp(m,:),'_Resultados\Rate_Analysis\Complete_Data');
        save(ruta_fin,'Data');
    end
end