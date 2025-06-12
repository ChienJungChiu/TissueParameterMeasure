%{
Calculate one round CV and plot all together

Recomende camera Settings:
1.at least take 3 pictures and analyze for average plot
2.Binning: 8x1



Chien-Jung Chiu
Last Update: 2025/1/21
%}

clc; close all; clear all;
%% Settings
inputfile = '20250102';
subfile = 'round';
BGfile = 'BG';
KineticSeriesLength = 20;   %how many picture did you take one time
round = 1;
%fiber_num = [1 3 5 7 9 11];
SDS_num = [1:6];
RTpixel = [212 232; 173 201; 137 170; 102 135; 70 91; 38 56];  %20250102
DeleteBG = 0;

%% Plot Settings
lineWidth=2;
fontSize=20;
LabelFontSize = 13;
lgdFontSize=10;
lgdNumCol=6;
color_arr=jet(KineticSeriesLength);
legend_arr={};
for i=1:KineticSeriesLength
    legend_arr{i}= ['pic ' num2str(i)];
end
legend_arr{end+1}='CV';

%initialize
spectra = [];

%% main
cd(inputfile);
figure;
for RN = 1:round
    curr_file = [subfile num2str(RN)];
    cd(curr_file)
    for SDS = 1:length(SDS_num)
        %image_all = [];
              
        for image_num = 1:KineticSeriesLength
            image_temp = [];
            image_temp(:,:,image_num)= imread(['ph1_SDS' num2str(SDS_num(SDS)) '_X' num2str(image_num) '.tif']);
            %% Do random track step
            spectra(image_num,:,SDS_num(SDS)) = sum(image_temp(RTpixel(SDS,1):RTpixel(SDS,2),:,image_num),1);
            subplot(2,3,SDS);
            plot(spectra(image_num,:,SDS_num(SDS)),'Color',color_arr(image_num,:),'LineWidth',lineWidth);
            title(['SDS ' num2str(SDS_num(SDS))],'fontsize',fontSize);
            % xticks(54:11.25:99);   %calculate
            xticks(42:11.25:87);   %TC
            xticklabels({'900','850','800','750','700'}); 
            xlabel('wavelength(nm)','fontsize',LabelFontSize);yyaxis left; ylabel('Measured intensity (CCD counts)','fontsize',LabelFontSize);
            lgd=legend(legend_arr,'Location','southoutside','fontsize',lgdFontSize);
            lgd.NumColumns = lgdNumCol;
            hold on;
        end
        CV(SDS_num(SDS),:) = std(spectra(:,:,SDS_num(SDS)),1)./mean(spectra(:,:,SDS_num(SDS)),1);

       %image_ave{SDS_num(SDS)} = mean(image_temp,3);
     
        % if DeleteBG == 1
        %     cd ..
        %     cd(BGfile);
        %     BG_all = [];
        %     for BG_num = 1:KineticSeriesLength
        %         BG_temp(:,:,BG_num) = imread(['ph1BG_SDS' num2str(SDS_num(SDS)) '_X' num2str(BG_num) '.tif']);
        %     end
        %     BG_ave{SDS_num(SDS)} = mean(BG_temp,3);
        % 
        %     image_wo_BG{SDS_num(SDS)} = image_ave{SDS_num(SDS)} - BG_ave{SDS_num(SDS)};
        %     ave_spectra{SDS_num(SDS)} = sum(image_wo_BG{SDS_num(SDS)}(RTpixel(SDS,1):RTpixel(SDS,2),:),1);
        %     cd ..
        %     cd(subfile);
        % elseif DeleteBG == 0
        %     ave_spectra{SDS_num(SDS)} = sum(image_ave{SDS_num(SDS)}(RTpixel(SDS,1):RTpixel(SDS,2),:),1);
        % end
    
       
        yyaxis right;
        
        CV(:,1:41) = NaN;
        CV(:,88:128) = NaN;
        
        CV_mean(SDS_num(SDS)) = mean(CV(SDS_num(SDS),42:87),2)*100
        %fprint(['The average CV of SDS' num2str(SDS_num(SDS)) ' is ' num2str(CV_mean(SDS_num(SDS))) '.']);

        plot(CV(SDS_num(SDS),:)*100,'--','LineWidth',lineWidth); %,'Color',[0 0 0]
        ylabel('CV(%)','fontsize',LabelFontSize);ylim([0 1]);
        lgd=legend(legend_arr,'Location','southoutside','fontsize',lgdFontSize);
        lgd.NumColumns = lgdNumCol;
    
        
        
    end
    cd ..
    CV_all_mean = mean(CV_mean(SDS_num(SDS)));
    fprintf(['The average CV of all SDSs is ' num2str(CV_mean(SDS_num(SDS))) '.\n'])
end