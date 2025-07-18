%{
use this script on phantom 1 to find the exosure time for each SDS

Chien-Jung Chiu
Last update: 2025/7/19
%}

clc;clear;close all;

%% param

output_dir='data/20250718';
% do_find_sds_pixel=1; % =1 if re-find the SDS location.
% do_find_shelter_pos=1; % =1 if re-find the shelter location.
% auto_find_shelter=1; % =1 to find the shelter location automatically.
% do_find_exp_time=1; % =1 if re-find the SDS exposure time.
% num_use_image=2; % how many SDS should use image mode to take in order to prevent overexposure, start from SDS 1

cd ..
% about camera
HBin=8; % horizontal binning
num_SDS=6;
shutter_open_time=0; % ms
shutter_close_time=0; % ms
SDS_location = load(fullfile(output_dir,'SDS_location.txt'));
SDS_take_mode = [1 1 2 2 2 2];
num_use_image=2; % how many SDS should use image mode to take in order to prevent overexposure, start from SDS 1
% SDS_exposure_time=load(fullfile(output_dir,'SDS_exposure_time.txt'));
SDS_ordering = [1:num_SDS];
random_track_pixel = load(fullfile(output_dir,'random_track_pixel.txt'));  %same as SDS_location but in 1x(2xnum_SDS) size

cd CameraCode
%% init

% cd(output_dir)
% if exist(output_dir,'dir')==0
%     mkdir(output_dir);
% end
ret=SetShutterEx(1,1,shutter_close_time,shutter_open_time,0); % set shutter
CheckWarning(ret);
[ret,XPixels, YPixels]=GetDetector; %   Get the CCD size
CheckWarning(ret);
[ret]=SetAcquisitionMode(1); % Set acquisition mode; 1 for Single Scan
CheckWarning(ret);
[ret]=SetBaselineClamp(0); % disable the baseline clamp
CheckWarning(ret);


%%
% % set to image mode, also other initial settings
% [ret]=SetAcquisitionMode(1); % Set acquisition mode; 1 for Single Scan
% CheckWarning(ret);
% [ret]=SetReadMode(4); % set read mode; 4 for Image
% CheckWarning(ret);
% ret=SetShutterEx(1,1,shutter_close_time,shutter_open_time,0); % set shutter
% CheckWarning(ret);
% [ret,XPixels, YPixels]=GetDetector; %   Get the CCD size
% CheckWarning(ret);
% [ret]=SetImage(HBin, 1, 1, XPixels, 1, YPixels); %   Set the image size
% CheckWarning(ret);
% [ret]=SetBaselineClamp(0); % disable the baseline clamp
% CheckWarning(ret);
%% take a image mode to make sure the shelter is at the right position
[ret]=SetAcquisitionMode(1); % Set acquisition mode; 1 for Single Scan
CheckWarning(ret);
[ret]=SetReadMode(4); % set read mode; 4 for Image
CheckWarning(ret);
[ret]=SetImage(HBin, 1, 1, XPixels, 1, YPixels); %   Set the image size
CheckWarning(ret);

exp_time=0.03; % secs
[ret]=SetExposureTime(exp_time); %   Set exposure time in second
CheckWarning(ret);

figure('Units','pixels','position',[0 0  1000 600]);
ti=tiledlayout(1,2,'TileSpacing','compact','Padding','none');
hSum=fun_take_picture_and_return_hSum(XPixels/HBin,YPixels,SDS_location);
title(ti,'image mode');
% print(fullfile(output_dir,['image.png']),'-dpng','-r400');
% save(fullfile(output_dir,['hSum_' subject_name '.txt']),'hSum','-ascii','-tabs');

% %% take one image
% fun_shelter_to_origianl();
% 
% exp_time=0.15; % secs
% [ret]=SetExposureTime(exp_time); %   Set exposure time in second
% CheckWarning(ret);
% 
% fprintf('Starting Acquisition for %f secs. ',exp_time);
% [ret] = StartAcquisition();
% CheckWarning(ret);
% [ret] = WaitForAcquisition();
% CheckWarning(ret);
% [ret, imageData] = GetMostRecentImage(XPixels/HBin * YPixels);
% CheckWarning(ret);
% if ret == atmcd.DRV_SUCCESS
%     %display the acquired image
%     imageData=transpose(reshape(imageData, XPixels/HBin, YPixels));
%     imagesc(imageData);
%     colormap(gray);
%     colorbar;
%     drawnow;
%     fprintf('Max gray level is %d\n',max(imageData(:)));
% else
%     error('Camera acquisition wrong!');
% end
% 
% %% find the pos for each SDS
% H_sum=sum(imageData,2); % the horizontal pixel sum
% % figure();
% [pks,locs,widths,proms]=findpeaks(H_sum,1:length(H_sum),'MinPeakProminence',400,'MinPeakDistance',10,'Annotate','extents');
% 
% if do_find_sds_pixel==1
%     [~,peak_index]=sort(pks,'descend');
%     SDS_location=zeros(length(pks),2);
%     for s=1:min(num_SDS,length(pks))
%         SDS_location(s,1)=round(locs(peak_index(s))-(widths(peak_index(s))+3));
%         SDS_location(s,2)=round(locs(peak_index(s))+(widths(peak_index(s))+3));
%     end
% 
%     % check if the SDS location is overlapping, if so, shrink the short SDS
%     for s=1:size(SDS_location,1)-1
%         if SDS_location(s,2)==SDS_location(s+1,1)
%             SDS_location(s,2)=SDS_location(s,2)-1;
%         end
%     end
% 
%     if length(pks)<num_SDS
%         while size(SDS_location,1)<num_SDS
%             warning('peak number not match to num_SDS! pleast adjust SDS_location!')
%             keyboard;
%         end
%     end
% else
%     SDS_location=load(fullfile(output_dir,'SDS_location.txt'));
%     assert(size(SDS_location,1)==num_SDS,'Error: SDS_location.txt not match with num_SDS!');
% end
% 
% pixel_isSorted=0;
% figure();
% 
% while pixel_isSorted==0
%     plot(H_sum);
%     hold on;
%     for s=1:num_SDS
%         fprintf('SDS %d V pixel range : [',s);
%         for j=1:2
%             xline(SDS_location(s,j));
%             text(SDS_location(s,j),max(pks),num2str(s));
%             fprintf('%d ',SDS_location(s,j));
%         end
%         fprintf(']\n');
%     end
%     hold off;
% 
%     [~,loc_index]=sort(SDS_location(:,1)); % the index of each probe location from small (Vpixel) to large
%     random_track_pixel=zeros(1,num_SDS*2);
%     for s=1:num_SDS
%         random_track_pixel(2*s-1:2*s)=SDS_location(loc_index(s),:);
%     end
% 
%     pixel_isSorted=issorted(random_track_pixel,'strictascend');
%     if pixel_isSorted==0
%         warning('SDS overlapped! Please change the SDS_location!');
%         keyboard();
%     end
% end
% 
% [~,SDS_ordering]=sort(loc_index); % the order of each SDS, e.g., [3 1 2]  means the SDS1 is the 3th fiber, SDS 2 is the 
% 
% %% save the SDS position
% save(fullfile(output_dir,'random_track_pixel.txt'),'random_track_pixel','-ascii','-tabs');
% save(fullfile(output_dir,'SDS_ordering.txt'),'SDS_ordering','-ascii','-tabs');
% save(fullfile(output_dir,'SDS_location.txt'),'SDS_location','-ascii','-tabs');
% 
% keyboard();
% %% find the position of shelter
% warning('Make sure the shelter is below SDS 1 now.\n');
% base_SDS_interval=2.5; % the baseline value of shelter to move to other location
% delta_SDS_interval=0.2; % the interval for each pos to move the shelter for `auto_find_shelter`
% autoFind_threshold=[2000 1500 1000 600 400]; % the error threshold for `auto_find_shelter`
% 
% if do_find_shelter_pos
%     SDS_v_pos_arr=zeros(num_SDS,1);
%     power_shift_threshold=0.02; % if the power shift is in this scale, than consider the SDS is not cover by the shelter
%     shelter_step_size=0.1; % move the shelter this second each time
%     % init
%     figure('Units','pixels','position',[0 0  1000 600]);
%     ti=tiledlayout(1,2,'TileSpacing','compact','Padding','none');
%     fprintf('Find the initial position for the shelter\n');
%     shelter_now_pos=0;
%     target_shelter_pos=0;
%     sds_okey=0;
%     while sds_okey==0
%         pos_to_move=target_shelter_pos-shelter_now_pos;
%         fun_shelter_move(pos_to_move);
%         shelter_now_pos=target_shelter_pos;
%         fun_take_picture_and_return_hSum(XPixels/HBin,YPixels,SDS_location);
%         title(ti,'SDS 1');
%         fprintf('Please adjust the target_shelter_pos, if the position is okey, please let sds_okey==1\n');
%         keyboard();
%     end
%     print(fullfile(output_dir,'shelter_SDS_1.png'),'-dpng','-r300');
% 
%     fun_reset_shelter_orig; % set this position as the shelter original
%     shelter_now_pos=0; % save this position as the shelter init position
%     SDS_v_pos_arr(1)=0;
% 
%     for s=2:num_SDS
%         fprintf('Adjusting shelter for SDS %d\n',s);
%         target_shelter_pos=shelter_now_pos+base_SDS_interval;
%         sds_okey=0;
%         while sds_okey==0
%             pos_to_move=target_shelter_pos-shelter_now_pos;
%             fun_shelter_move(pos_to_move);
%             shelter_now_pos=target_shelter_pos;
%             img_hSum=fun_take_picture_and_return_hSum(XPixels/HBin,YPixels,SDS_location);
%             title(ti,['SDS ' num2str(s)]);
% 
%             SDS_hSum=img_hSum(SDS_location(s-1,1):SDS_location(s-1,2));
%             temp_xx=1:length(SDS_hSum);
%             temp_p=polyfit(temp_xx,SDS_hSum,1);
%             temp_y=polyval(temp_p,temp_xx);
%             to_flat_error=SDS_hSum-temp_y'; % the error from the now SDS to a flat SDS
%             to_flat_error=max(to_flat_error)-min(to_flat_error); % the error from the now SDS to a flat SDS
%             fprintf('The SDS %d is %d to flat\n',s-1,to_flat_error);
% 
%             if auto_find_shelter
%                 if to_flat_error<=autoFind_threshold(s-1)
%                     sds_okey=1;
%                 else
%                     target_shelter_pos=target_shelter_pos+delta_SDS_interval;
%                 end
%             else
%                 fprintf('Please adjust the target_shelter_pos, if the position is okey, please set sds_okey==1\n');
%                 keyboard();
%             end
%         end
%         SDS_v_pos_arr(s)=shelter_now_pos;
%         print(fullfile(output_dir,['shelter_SDS_' num2str(s) '.png']),'-dpng','-r300');
%     end
% 
%     save(fullfile(output_dir,'SDS_v_pos_arr.txt'),'SDS_v_pos_arr','-ascii','-tabs');
% 
%     fprintf('Moving shelter back to init from %f.\n',shelter_now_pos);
%     % fun_shelter_move(-shelter_now_pos);
%     fun_shelter_to_origianl
% else
%     SDS_v_pos_arr=load(fullfile(output_dir,'SDS_v_pos_arr.txt'));
%     assert(length(SDS_v_pos_arr)==num_SDS,'Error: SDS_v_pos_arr.txt not match with num_SDS!');
% end
% 
% keyboard();

%% adjust the exporesure time (for the short SDS)
beep; % to notice that the picture will begin
% if do_find_exp_time
    
    figure();
    init_exp_time=0.05; % the initial exposure time, in secs
    max_exp_time=10; % secs
    GL_thredhold=[55000 45000]; % the upper bound and lower bound for the gray level threshold
    expTime_change_ratio=1.1; % the change rate of exposure time
    SDS_exposure_time_arr=zeros(1,num_SDS);
    %SDS_take_mode=[ones(1,num_use_image) 2*ones(1,num_SDS-num_use_image)]; % 1 for image mode, 2 for random-track mode

    now_take_mode=0; % initial take mode: nothiong
    % shelter_now_pos=0;
    % fun_shelter_to_origianl
    exp_time=init_exp_time;
    cd ..
    for s=1:num_SDS
        % move the shelter
        fprintf('Please Move shelter to SDS %d\n',s);
        keyboard();
        
        % fun_shelter_move(SDS_v_pos_arr(s)-shelter_now_pos);
        % shelter_now_pos=SDS_v_pos_arr(s);
        
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

        max_pixel_value=80000; % a dummy value to get in while loop
        while max_pixel_value>GL_thredhold(1) | max_pixel_value<GL_thredhold(2)
            [ret]=SetExposureTime(exp_time); %   Set exposure time in second
            CheckWarning(ret);

            fprintf('Starting Acquisition for %f secs. ',exp_time);
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
            
            if ret == atmcd.DRV_SUCCESS
                %display the acquired image
                if now_take_mode==1
                    % image mode
                    imageData=reshape(imageData, XPixels/HBin, YPixels);
                    temp_image=zeros(XPixels/HBin,num_SDS);
                    for temp_s=1:num_SDS
                        temp_image(:,temp_s)=max(imageData(:,random_track_pixel(temp_s*2-1):random_track_pixel(temp_s*2)),[],2);
                    end
                    imageData=temp_image;
                elseif now_take_mode==2
                    % random track mode
                    imageData=reshape(imageData, XPixels/HBin, num_SDS);
                end
                plot(imageData);
                title(['SDS ' num2str(s) ', exp time =' num2str(exp_time)]);
                drawnow;
                max_pixel_value=max(imageData(:,SDS_ordering(s)));
                fprintf('Max gray level for SDS %d is %d\n',s,max_pixel_value);
                if max_pixel_value<GL_thredhold(2)
                    exp_time=exp_time*expTime_change_ratio;
                elseif max_pixel_value>GL_thredhold(1)
                    exp_time=exp_time/expTime_change_ratio;
                end
            else
                error('Camera acquisition wrong!');
            end
            if exp_time>max_exp_time
                exp_time=max_exp_time;
                break;
            end
        end
        
        print(fullfile(output_dir,['exposure_SDS_' num2str(s) '.png']),'-dpng','-r300');
        SDS_exposure_time_arr(s)=exp_time;
        if s~=num_SDS
            if s>=num_use_image+1
                exp_time=min(max_exp_time,exp_time*double(max(imageData(:,SDS_ordering(s))))/double(max(imageData(:,SDS_ordering(s+1)))))-init_exp_time;
            else
                exp_time=init_exp_time; % from image mode SDS to random track SDS
            end
        end
    end
    
    %cd(output_dir)
    save(fullfile(output_dir,'SDS_exposure_time.txt'),'SDS_exposure_time_arr','-ascii','-tabs');
    save(fullfile(output_dir,'SDS_take_mode.txt'),'SDS_take_mode','-ascii','-tabs');
    % fprintf('Moving shelter back to init from %f.\n',shelter_now_pos);
    % fun_shelter_move(-shelter_now_pos);
    % fun_shelter_to_origianl
% else
%     SDS_exposure_time_arr=load(fullfile(output_dir,'SDS_exposure_time.txt'));
%     assert(length(SDS_exposure_time_arr)==num_SDS,'Error: SDS_exposure_time.txt not match with num_SDS!');
%     SDS_take_mode=load(fullfile(output_dir,'SDS_take_mode.txt'));
%     assert(length(SDS_take_mode)==num_SDS,'Error: SDS_take_mode.txt not match with num_SDS!');
% end

disp('Done!');

%% functions
