%{
Continuous use the camera to take picture
For adjust the system

Edit Benjamin Kao's code by Chien-Jung Chiu
Last update: 2025/6/3
%}

clc;clear;close all;

%% param
% about plot
use_log_scale=1;

% about camera
HBin=8; % horizontal binning
num_SDS=6;
%num_picture=10; % how many picture to take for one SDS
shutter_open_time=0; % ms
shutter_close_time=0; % ms

%% init
[ret]=SetAcquisitionMode(1); % Set acquisition mode; 1 for Single Scan
CheckWarning(ret);
[ret]=SetReadMode(4); % set read mode; 4 for Image
CheckWarning(ret);
ret=SetShutterEx(1,1,shutter_close_time,shutter_open_time,0); % set shutter
CheckWarning(ret);
[ret,XPixels, YPixels]=GetDetector; %   Get the CCD size
CheckWarning(ret);
[ret]=SetImage(HBin, 1, 1, XPixels, 1, YPixels); %   Set the image size
CheckWarning(ret);

%% take one image
exp_time=0.03; % secs
[ret]=SetExposureTime(exp_time); %   Set exposure time in second
CheckWarning(ret);

figure('Units','pixels','position',[0 0  1000 600]);
ti=tiledlayout(1,2,'TileSpacing','compact','Padding','none');

while true
    fprintf('Starting Acquisition for %f secs. ',exp_time);
    [ret] = StartAcquisition();
    CheckWarning(ret);
    [ret] = WaitForAcquisition();
    CheckWarning(ret);
    [ret, imageData] = GetMostRecentImage(XPixels/HBin * YPixels);
    CheckWarning(ret);
    if ret == atmcd.DRV_SUCCESS
        %display the acquired image
        imageData=transpose(reshape(imageData, XPixels/HBin, YPixels));
        nexttile(1);
        imagesc(imageData);
        colormap(gray);
        if use_log_scale
            set(gca,'colorscale','log');
        end
        colorbar;
        nexttile(2);
        plot(sum(imageData,2));
        if use_log_scale
            set(gca,'YScale','log');
        end
        grid on;
        drawnow;
        fprintf('Max gray level is %d\n',max(imageData(:)));
    else
        error('Camera acquisition wrong!');
    end
end