%{
To normalize and quantify the stability of stge or baffle


Chien-Jung Chiu
Last Update:2025/5/16
%}


close all; clear all; clc;
folder ='20250514';
file = '20250514擋板準確度分析.xlsx';
% SDS1 = xlsread('20250305平移台準確度分析.xlsx',1);
% SDS6 = xlsread('20250305平移台準確度分析.xlsx',2);
SDS_num = [1 6];

kinetic = 3;
round = 10;
SDSdist = 8.4-3.2;

%% analysis settings
max_range = [661 83];   %it'll follow the respect SDS from line7
FOV_range = 5; %50
doKineticSeriesAverage = 1;
doStageTest = 0;
doBaffleTest = 1;
assert(doStageTest*doBaffleTest == 0, 'Pick the exact test you did!');
%Resolution = SDSdist/pixDiff *1000; %unit: mum/pixel


cd(folder);
for i = 1:length(SDS_num)
    %data = ['SDS' num2str(SDS_num(i))];
    
    data = xlsread(file,i);
    %% delete NaN row (there are NaN row may because of chr/words)
    if isnan(data(1,1))
        data(1,:) = [];
    end
    MeanOfOneRound = [];
    figure;
    for num = 1:round
        %% take average for kinetic
        if doKineticSeriesAverage == 1
            for k = 1:kinetic
                
                if k == 1
                    MeanOfOneRound = data(:,7*(num-1)+2*k);
                else
                    MeanOfOneRound = data(:,7*(num-1)+2*k)+ MeanOfOneRound;
                end

            end
            data(:,num*(2*kinetic+1)) = MeanOfOneRound./kinetic;

        end


        %% find max average & normalize
        if doStageTest == 1
            maxAve = mean(data(1:max_range(i),num*(2*kinetic+1)),1);
            dataNOR = data./maxAve;
            plot(dataNOR(1:max_range(i)+FOV_range,num*(2*kinetic+1)));
        elseif doBaffleTest == 1
            dataNOR = data./max(data(max_range(i)-FOV_range:max_range(i),num*(2*kinetic+1)),[],"all");
            plot(dataNOR((max_range(i)-FOV_range):(max_range(i)+FOV_range),num*(2*kinetic+1)));

        end
        % if doKineticSeriesAverage == 0
        %     plot(dataNOR(1:max_range(i)+50,num*(2*kinetic+1)));
        % elseif doKineticSeriesAverage == 1
        % 
        % end
        %plot(dataNOR(max_range(i):max_range(i)+50,num*(2*kinetic+1)));  %2*kinetic+1 is because I already take the average of all kinetics
        title(['SDS' num2str(SDS_num(i))])
        xlabel('pixel');

        %% interpolation to find the value of 0.5
        % [~,Mpos(i,num)] = min(abs(data(:,num*(2*kinetic+1)) - maxAve(1,num*(2*kinetic+1))/2)); %find the point which is the nearest to the average 
        [temp,Mpos(i,num)] = min(abs(dataNOR((max_range(i)-FOV_range):max_range(i),num*(2*kinetic+1)) - 0.5));    %find the points which are the nearest to 0.5
        
        closePOS(i,num) = max_range(i)-FOV_range+Mpos(i,num)-1;
        if temp == 0
            median(i,num) = dataNOR(closePOS(i,num),num*(2*kinetic+1));
        elseif dataNOR(closePOS(i,num),num*(2*kinetic+1))-0.5 < 0
            median(i,num) = Interpolation(0.5, dataNOR(closePOS(i,num)-1,num*(2*kinetic+1)), dataNOR(closePOS(i,num),num*(2*kinetic+1)), closePOS(i,num)-1, closePOS(i,num));
        elseif dataNOR(closePOS(i,num),num*(2*kinetic+1))-0.5 > 0
            % high = dataNOR(Mpos(i,num),num*(2*kinetic+1));
            % low = dataNOR(Mpos(i,num)+1,num*(2*kinetic+1));
            median(i,num) = Interpolation(0.5, dataNOR(closePOS(i,num),num*(2*kinetic+1)), dataNOR(closePOS(i,num)+1,num*(2*kinetic+1)), closePOS(i,num), closePOS(i,num)+1);
        end



        %[~,Mpos(i,num)] = min(abs(data(:,num*(2*kinetic+1)) - 0.5));  
        % median(i,num) = dataNOR(Mpos(i,num),num*(2*kinetic+1));
        hold on;
        %plot(dataNOR(idx,num*(2*kinetic+1)),'LineWidth', 30);
        disp(['The pixel of half height at SDS' num2str(SDS_num(i)) ' is about ' num2str(closePOS(i,num)) ', and the interpolation value is ' num2str(median(i,num)) '.']);
        

    end
    medDiff(i) = max(median(i,:))-min(median(i,:));
    medPosDiff(i) = max(closePOS(i,num))-min(closePOS(i,num));
    %disp(['The most different pixel of half height at SDS' num2str(SDS_num(i)) ' is ' num2str(medPosDiff(i)) '.'])
    %disp(['The most different position of half height at SDS' num2str(SDS_num(i)) ' is ' num2str(medDiff(i)) '.'])
    disp(['The range of interpolation half height at SDS' num2str(SDS_num(i)) ' is ' num2str(medDiff(i)) '.'])



end

function IntPOS = Interpolation(IntValue, high, low, highPOS, lowPOS)
IntPOS = (IntValue-low)./(high-low)*(highPOS-lowPOS) + lowPOS;

end