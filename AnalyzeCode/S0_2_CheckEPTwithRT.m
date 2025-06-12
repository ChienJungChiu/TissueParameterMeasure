%{
Check exposure time with Random track pixel

Recomende camera Settings:
1.take 3 pictures and analyze for average plot
2.Binning: 8x1



Chien-Jung Chiu
Last Update: 2025/1/15

%}

clc; close all; clear all;
%% Settings
inputfile = '20250102';
subfile = 'round1';
BGfile = 'BG1';
KineticSeriesLength = 20;   %how many picture did you take one time
%fiber_num = [1 3 5 7 9 11];
SDS_num = [1:6];
RTpixel = [ 212 232; 173 201; 137 170; 102 135; 70 91; 38 56];  %20250102
DeleteBG = 0;

%% main
cd(fullfile(inputfile,subfile));
figure;
for SDS = 1:length(SDS_num)
    image_all = [];
    image_temp = [];
    %cd(subfile);
    for image_num = 1:KineticSeriesLength
        %image_temp = imread(['ph1_SDS1_f' num2str(fiber_num(fnum)) '_X' num2str(image_num) '.tif']);
        image_temp(:,:,image_num)= imread(['ph1_SDS' num2str(SDS_num(SDS)) '_X' num2str(image_num) '.tif']);
        %image_temp = imread(['ph1_SDS' num2str(SDS_num(SDS)) '_X15.tif']);
        % if image_num == 1
        %     image_all = image_temp; 
        % else
        %     image_all = image_all + image_temp;    
        % end
        % test = sum(image_temp(RTpixel(SDS,1):RTpixel(SDS,2),:),1);
        % plot(test);
        % hold on;
    end
    % image_ave{SDS_num(SDS)} = image_all./KineticSeriesLength;
    image_ave{SDS_num(SDS)} = mean(image_temp,3);
    %ave_spectra{SDS} = sum(image_ave{SDS_num(SDS)}(RTpixel(SDS,1):RTpixel(SDS,2),:),1);
    
    
    
    if DeleteBG == 1
        cd ..
        cd(BGfile);
        BG_all = [];
        for BG_num = 1:KineticSeriesLength
            %image_temp = imread(['ph1_SDS1_f' num2str(fiber_num(fnum)) '_X' num2str(image_num) '.tif']);
            BG_temp(:,:,BG_num) = imread(['ph1BG_SDS' num2str(SDS_num(SDS)) '_X' num2str(BG_num) '.tif']);
            % if BG_num == 1
            %     BG_all = BG_temp; 
            % else
            %     BG_all = BG_all + BG_temp;    
            % end
        end
        BG_ave{SDS_num(SDS)} = mean(BG_temp,3);
        
        image_wo_BG{SDS_num(SDS)} = image_ave{SDS_num(SDS)} - BG_ave{SDS_num(SDS)};
        ave_spectra{SDS_num(SDS)} = sum(image_wo_BG{SDS_num(SDS)}(RTpixel(SDS,1):RTpixel(SDS,2),:),1);
        cd ..
        cd(subfile);
    elseif DeleteBG == 0
        ave_spectra{SDS_num(SDS)} = sum(image_ave{SDS_num(SDS)}(RTpixel(SDS,1):RTpixel(SDS,2),:),1);
    end


    
    subplot(2,3,SDS);
    %legend(SDS)
    % title('SDS ');% num2str(SDS)])
    plot(ave_spectra{SDS_num(SDS)});
    title(['SDS ' num2str(SDS_num(SDS))]);
    xlabel('pixel');
    ylabel('Reflectance');
    
    
    
end