%{
Calculate several rounds CV and plot all rounds together

Recomende camera Settings:
1.at least take 3 pictures and analyze for average plot
2.Binning: 8x1



Chien-Jung Chiu
Last Update: 2025/1/21
%}

clc; close all; clear all;
%% Settings
inputfile = '20250515';
subfile = 'round';
BGfile = 'BG';
KineticSeriesLength = 3;   %how many picture did you take one time
round = 5;
%fiber_num = [1 3 5 7 9 11];
SDS_num = [1];
time = [15 30 45 60 75];
%RTpixel = [212 232; 173 201; 137 170; 102 135; 70 91; 38 56];  %20250102
RTpixel = [202 219];  %20250118
DeleteBG = 0;
Hbin = 8;
Horizontal_pixel = 1024;

%% Plot Settings
lineWidth=2;
fontSize=20;
LabelFontSize = 13;
lgdFontSize=15;
lgdNumCol=3;
color_arr=jet(round);
legend_arr={};
for i=1:round
    legend_arr{i}= ['round ' num2str(i)];
end
legend_arr{end+1}='CV';

%initialize
spectra = [];
CV = [];

%% main
cd(inputfile);
figure;

for time_num = 1:length(time)
    %for RN = 1:round
        %curr_file = [subfile num2str(RN)];
        %cd(curr_file)

        %image_all = [];
              
        for image_num = 1:KineticSeriesLength
            image_temp = [];
            image_temp(:,:,image_num)= imread(['ph1_f11_' num2str(time(time_num)) '_X' num2str(image_num) '.tif']);
            %% Do random track step
            spectra(image_num,:) = sum(image_temp(RTpixel(SDS_num,1):RTpixel(SDS_num,2),:,image_num),1);
            %mean_spectra{SDS}(RN,:) =  mean(spectra(image_num,:,SDS_num(SDS)),1);
        end
        mean_spectra(time_num,:) =  mean(spectra,1);
        %plot_mean = mean_spectra(SDS,RN,:);
        %subplot(2,3,time_num);
        plot(mean_spectra(time_num,:),'-','Color',color_arr(time_num,:),'LineWidth',lineWidth);
        %xline([54 99],'LineWidth',lineWidth) %900 700 -> 433.58 790.159
        %title(['SDS ' num2str(SDS_num(time_num))],'fontsize',fontSize);
        xticks(42:11.25:87);
        xticklabels({'900','850','800','750','700'}); 
        xlabel('wavelength(nm)','fontsize',LabelFontSize);yyaxis left; ylabel('Measured intensity (CCD counts)','fontsize',LabelFontSize);
        lgd=legend(legend_arr,'Location','southoutside','fontsize',lgdFontSize);
        lgd.NumColumns = lgdNumCol;
        hold on;
        
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
    

       %cd ..   
    % end
    % 
    % 
    % 
    
    

end

CV = std(mean_spectra(time_num,:),1)./mean(mean_spectra(time_num,:),1);
yyaxis right;
CV(1:41) = NaN;
CV(88:128) = NaN;
%CV_mean(SDS_num(time_num)) = mean(CV(SDS_num(time_num),42:87),2)*100
plot(CV*100,'--k','LineWidth',lineWidth); %,'Color',[0 0 0]
ylabel('CV(%)','fontsize',LabelFontSize);ylim([0 70]);
lgd=legend(legend_arr,'Location','southoutside','fontsize',lgdFontSize);
lgd.NumColumns = lgdNumCol;

    % CV_all_mean = mean(CV_mean(SDS_num(SDS)));
    % fprintf(['The average CV of all SDSs is ' num2str(CV_mean(SDS_num(SDS))) '.\n'])
% CV_all_mean = mean(CV_mean(SDS_num(time_num)));
% fprintf(['The average CV of all SDSs is ' num2str(CV_mean(SDS_num(time_num))) '.\n']);



% figure;
% %%compare with TC's thesis table22
% TC_CV = [3 4.2 5.1 5.2 5.4 12.1];
% bar([TC_CV; CV_mean]', 'grouped');
% legend('Previous ( 3 subjects)', 'New ( 1 subject)');
% xlabel('SDS','fontsize',LabelFontSize);yyaxis left; ylabel('CV(%)','fontsize',LabelFontSize);
% yyaxis right;
% set(gca, 'YTick', []); 
% set(gca, 'YColor', 'none'); 
