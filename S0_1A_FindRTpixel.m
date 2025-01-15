%{
Check each fiber peak for random track pixel interval

Recomende camera Settings:
1.take 3 pictures and analyze for average plot
2.Binning: 8x1



Chien-Jung Chiu
Last Update: 2025/1/9

%}

clc; close all; clear all;
%% Settings
%inputfile = '20250109/SDS1forRT';
inputfile = '20241231';
KineticSeriesLength = 3;   %how many picture did you take one time
fiber_num = [1 3 5 7 9 11];
%% main

%initialize

cd(inputfile);
figure;
for fnum = 1:length(fiber_num)
    image_all = [];
    for image_num = 1:KineticSeriesLength
        %image_temp = imread(['ph1_SDS1_f' num2str(fiber_num(fnum)) '_X' num2str(image_num) '.tif']);
        image_temp = imread(['ph1_f' num2str(fiber_num(fnum)) '_X' num2str(image_num) '.tif']);
        if image_num == 1
            image_all = image_temp; 
        else
            image_all = image_all + image_temp;    
        end
    end
    image_ave{fiber_num(fnum)} = image_all./KineticSeriesLength;
    [max_value(fnum),~] =max(image_ave{fiber_num(fnum)},[],"all");
    %[a(fnum),b(fnum)] = find(image_ave{fiber_num(fnum)}==max_value(fnum));
    plot(image_ave{fiber_num(fnum)} (:,61));  %about 60,61
    legend('1','3','5','7','9','11')
    hold on;
    
end
