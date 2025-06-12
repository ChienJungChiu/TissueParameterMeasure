%{
Calculate crosstalk

Recomende camera Settings:
1.at least take 3 pictures and analyze for average plot
2.Binning: 8x1


Chien-Jung Chiu
Last Update: 2025/1/21
%}

clc; close all; clear all;
%% Settings
inputfile = '20250113';
subfile = 'crosstalk';
BGfile = 'BG';
KineticSeriesLength = 5;   %how many picture did you take one time
round = 1;
%fiber_num = [1 3 5 7 9 11];
SDS_num = [1:6];
RTpixel = [206 224; 170 193; 131 162; 97 121; 65 84; 34 50];  %20250109
DeleteBG = 0;

%% Plot Settings
lineWidth=2;
fontSize=20;
LabelFontSize = 13;
lgdFontSize=10;
lgdNumCol=6;
%color_arr=jet(4);
legend_arr={};
% for i=1:KineticSeriesLength
%     legend_arr{i}= ['pic ' num2str(i)];
% end
legend_arr{1}='signal';
legend_arr{2}='Cross-talk';
legend_arr{3}='all';
legend_arr{4}='Cross-talk effect';

%initialize
spectra = [];

%% main
cd(inputfile);
figure;
%for RN = 1:round
    %curr_file = [subfile num2str(RN)];
    cd(subfile)
    for SDS = 1:length(SDS_num)
        %image_all = [];
              
        for image_num = 1:KineticSeriesLength
            single_image = [];
            single_image(:,:,image_num)= imread(['ph1_SDS' num2str(SDS_num(SDS)) '_s_X' num2str(image_num) '.tif']);
            others_image = [];
            others_image(:,:,image_num)= imread(['ph1_SDS' num2str(SDS_num(SDS)) '_wo_X' num2str(image_num) '.tif']);
            all_image = [];
            all_image(:,:,image_num)= imread(['ph1_SDS' num2str(SDS_num(SDS)) '_all_X' num2str(image_num) '.tif']);
            %% Do random track step
            single_spectra(image_num,:,SDS_num(SDS)) = sum(single_image(RTpixel(SDS,1):RTpixel(SDS,2),:,image_num),1);
            others_spectra(image_num,:,SDS_num(SDS)) = sum(others_image(RTpixel(SDS,1):RTpixel(SDS,2),:,image_num),1);  %cross-talk
            all_spectra(image_num,:,SDS_num(SDS)) = sum(all_image(RTpixel(SDS,1):RTpixel(SDS,2),:,image_num),1);  %cross-talk
        end
        mean_single(SDS_num(SDS),:) =  mean(single_spectra(:,:,SDS_num(SDS)),1);
        mean_others(SDS_num(SDS),:) =  mean(others_spectra(:,:,SDS_num(SDS)),1);
        mean_all(SDS_num(SDS),:) =  mean(all_spectra(:,:,SDS_num(SDS)),1);
    
        subplot(2,3,SDS);
        plot(mean_single(SDS_num(SDS),:),'LineWidth',lineWidth);
        hold on;
        plot(mean_others(SDS_num(SDS),:),'LineWidth',lineWidth);
        hold on;
        plot(mean_all(SDS_num(SDS),:),'LineWidth',lineWidth);
        title(['SDS ' num2str(SDS_num(SDS))],'fontsize',fontSize);
        xticks(54:11.25:99);
        xticklabels({'900','850','800','750','700'}); 
        xlabel('wavelength(nm)','fontsize',LabelFontSize);yyaxis left; ylabel('Reflectance','fontsize',LabelFontSize);
        lgd=legend(legend_arr,'Location','southoutside','fontsize',lgdFontSize);
        lgd.NumColumns = lgdNumCol;
        hold on;
        crosstalk_effect(SDS_num(SDS),:) = mean_others(SDS_num(SDS),:)./mean_single(SDS_num(SDS),:);
       
        yyaxis right;
        
        crosstalk_effect(:,1:53) = NaN;
        crosstalk_effect(:,100:128) = NaN;
        plot(crosstalk_effect(SDS_num(SDS),:)*100,'--','LineWidth',lineWidth); %,'Color',[0 0 0]
        ylabel('Cross-talk effect(%)','fontsize',LabelFontSize);
        lgd=legend(legend_arr,'Location','southoutside','fontsize',lgdFontSize);
        lgd.NumColumns = lgdNumCol;
    
        
        
    end
    cd ..
%end