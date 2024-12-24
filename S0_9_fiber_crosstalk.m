clc; clear all; close all;
inputfile = '20240802';
%t = Tiff('ph1_6_X1.tif');
% imageData = read(fullfile(inputfile,t));
cd(inputfile)
% fiber6 = Tiff('ph1_6_X1.tif','r');
% fiber6Data = read(fiber6);
% fiber7 = Tiff('ph1_7_X1.tif','r');
% fiber7Data = read(fiber7);
% fiber8 = Tiff('ph1_8_X1.tif','r');
% fiber8Data = read(fiber8);
% fiber9 = Tiff('ph1_9_X1.tif','r');
% fiber9Data = read(fiber9);
% fiber10 = Tiff('ph1_10_X1.tif','r');
% fiber10Data = read(fiber10);
% fiber11 = Tiff('ph1_11_X1.tif','r');
% fiber11Data = read(fiber11);
figure;
ub_sum = [];
lb_sum = [];
image_ub_temp = [];
image_lb_temp = [];
for SDS_num = 1:6
    for image_num = 1:3
        image_ub_temp = imread(['PH1_' num2str(SDS_num) 'ub_X' num2str(image_num) '.tif']);
        image_lb_temp = imread(['PH1_' num2str(SDS_num) 'lb_X' num2str(image_num) '.tif']);
        if image_num == 1
            ub_sum = image_ub_temp;
            lb_sum = image_lb_temp;
        else
            ub_sum = image_ub_temp + ub_sum;
            lb_sum = image_lb_temp + lb_sum;
        end
        
    end
    ub_ave{SDS_num} = ub_sum./3;
    lb_ave{SDS_num} = lb_sum./3;
    % with binning will be much easier to print
%     [M,~] = max(ub_ave{2*SDS_num-1}(:));
%     [row(2*SDS_num-1),col(2*SDS_num-1)] = find(ub_ave{2*SDS_num-1}==M);
    subplot(6,2,2*SDS_num-1);
%     plot(ub_ave{SDS_num}(:,col(2*SDS_num-1)))
    plot(ub_ave{SDS_num}(:,741));
    hold on;
%     [M,~] = max(lb_ave{SDS_num});
%     [row(2*SDS_num),col(2*SDS_num)] = find(lb_ave{SDS_num}==M);
    subplot(6,2,2*SDS_num);
%     plot(lb_ave{SDS_num}(:,col(2*SDS_num)));
    plot(lb_ave{SDS_num}(:,741));
    hold on;

end
