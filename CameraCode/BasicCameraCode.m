%{
The basic camera test code

Chien-Jung Chiu
Last Updtae: 2025/6/3
%}

clc;clear;close all;

%% param
% about camera
HBin=8; % horizontal binning
shutter_open_time=0; % ms
shutter_close_time=0; % ms

%% init
[ret]=SetAcquisitionMode(1); % Set acquisition mode; 1 for Single Scan
CheckWarning(ret);
[ret]=SetReadMode(4); % set read mode; 4 for Image
CheckWarning(ret);
%ret=SetShutterEx(1,1,shutter_close_time,shutter_open_time,0); % set shutter
%CheckWarning(ret);
[ret,XPixels, YPixels]=GetDetector; %   Get the CCD size
CheckWarning(ret);
[ret]=SetImage(HBin, 1, 1, XPixels, 1, YPixels); %   Set the image size
CheckWarning(ret);