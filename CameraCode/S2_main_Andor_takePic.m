%{
The basic camera test code

Chien-Jung Chiu
Last Updtae: 2025/6/12
%}

clc;clear;close all;

cd ..
%% param
output_dir='data/20250612';
subject_name='ph1_R5';
file_name_prefix='SDS_spec_arr_'; % the file will be save to [file_name_prefix subject_name '.mat']

% about camera
HBin=8; % horizontal binning
num_SDS=6;
num_picture=[10 8 10 8 6 3]; % how many picture to take for one SDS
shutter_open_time=0; % ms
shutter_close_time=0; % ms
SDS_location = load(fullfile(output_dir,'SDS_location.txt'));
SDS_take_mode = [1 1 2 2 2 2];
SDS_exposure_time=load(fullfile(output_dir,'SDS_exposure_time.txt'));
SDS_ordering = [1:num_SDS];
random_track_pixel = load(fullfile(output_dir,'random_track_pixel.txt'));  %same as SDS_location but in 1x(2xnum_SDS) size

%% init
ret=SetShutterEx(1,1,shutter_close_time,shutter_open_time,0); % set shutter
CheckWarning(ret);
[ret,XPixels, YPixels]=GetDetector; %   Get the CCD size
CheckWarning(ret);
[ret]=SetAcquisitionMode(1); % Set acquisition mode; 1 for Single Scan
CheckWarning(ret);
[ret]=SetBaselineClamp(0); % disable the baseline clamp
CheckWarning(ret);

%% acquisition
beep; % to notice that the picture will begin

%% take a image mode to make sure the shelter is at the right position
[ret]=SetAcquisitionMode(1); % Set acquisition mode; 1 for Single Scan
CheckWarning(ret);
[ret]=SetReadMode(4); % set read mode; 4 for Image
CheckWarning(ret);
[ret]=SetImage(HBin, 1, 1, XPixels, 1, YPixels); %   Set the image size
CheckWarning(ret);

exp_time=0.15; % secs
[ret]=SetExposureTime(exp_time); %   Set exposure time in second
CheckWarning(ret);

figure('Units','pixels','position',[0 0  1000 600]);
ti=tiledlayout(1,2,'TileSpacing','compact','Padding','none');
hSum=fun_take_picture_and_return_hSum(XPixels/HBin,YPixels,SDS_location);
title(ti,[subject_name ' image mode']);
print(fullfile(output_dir,['image_' subject_name '.png']),'-dpng','-r400');
save(fullfile(output_dir,['hSum_' subject_name '.txt']),'hSum','-ascii','-tabs');

%% main shut
SDS_spec_arr=cell(1,num_SDS);
now_take_mode=0; % initial take mode: nothiong

for s=1:num_SDS
   % move the shelter
    fprintf('Moving shelter to SDS %d\n',s); 
    keyboard();

    % set the take mode
    if now_take_mode~=SDS_take_mode(s)
        if SDS_take_mode(s)==1
            fprintf('Set read mode to image mode!\n');
            % set the mode to image mode
            [ret]=SetReadMode(4); % set read mode; 4 for Image
            CheckWarning(ret);
            [ret]=SetImage(HBin, 1, 1, XPixels, 1, YPixels); %   Set the image size
            CheckWarning(ret);
            now_take_mode=1;
        elseif SDS_take_mode(s)==2
            fprintf('Set read mode to ramdom track mode!\n');
            % set the mode to random track
            [ret]=SetReadMode(2); % set read mode; 2 for random track
            CheckWarning(ret);
            [ret]=SetCustomTrackHBin(HBin); % set binning for random track mode
            CheckWarning(ret);
            [ret]=SetRandomTracks(num_SDS,random_track_pixel); % set the vertical position of the random track
            CheckWarning(ret);
            now_take_mode=2;
        end
        [ret]=SetBaselineClamp(0); % disable the baseline clamp
        CheckWarning(ret);
    end

    % set exposure time
    ret=SetExposureTime(SDS_exposure_time(s)); % set exposure time
    CheckWarning(ret);

    for i=1:num_picture(s)
        fprintf('Take pic for SDS %d - %d, exp time is %.2f secs...',s,i,SDS_exposure_time(s));
        % start take picture
        [ret] = StartAcquisition();
        CheckWarning(ret);
        [ret] = WaitForAcquisition();
        CheckWarning(ret);
        
        if now_take_mode==1
            % image mode
            [ret, imageData] = GetMostRecentImage(XPixels/HBin * YPixels);
            CheckWarning(ret);
        elseif now_take_mode==2
            % random track mode
            [ret, imageData] = GetMostRecentImage(XPixels/HBin * num_SDS);
            CheckWarning(ret);
        end
        
        CheckWarning(ret);
        if ret == atmcd.DRV_SUCCESS
            %display the acquired image
            if now_take_mode==1
                % image mode
                imageData=reshape(imageData, XPixels/HBin, YPixels);
                temp_image=zeros(XPixels/HBin,num_SDS);
                for temp_s=1:num_SDS
                    temp_image(:,temp_s)=sum(imageData(:,random_track_pixel(temp_s*2-1):random_track_pixel(temp_s*2)),2);
                end
                imageData=temp_image;
            elseif now_take_mode==2
                % random track mode
                imageData=reshape(imageData, XPixels/HBin, num_SDS);
            end
            plot(imageData);
            legend;
            drawnow;
            max_pixel_value=max(imageData(:,SDS_ordering(s)));
            fprintf(', Max gray level is %d\n',max_pixel_value);
            SDS_spec_arr{s}(:,i)=imageData(:,SDS_ordering(s));
        else
            error('Camera acquisition wrong!');
        end
    end

end

%% end
save(fullfile(output_dir,[file_name_prefix subject_name '.mat']),'SDS_spec_arr');

beep; % make a sound to notice the capture is done.

disp('Done!');