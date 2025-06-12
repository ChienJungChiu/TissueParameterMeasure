%{
Turn on the camera and cool it until the temparature is low enough

Benjamin Kao
Last update: 2020/11/11
%}

%% param
target_temp=-50;

%% init
disp('Initializing Camera');
ret=AndorInitialize('');
CheckError(ret);

%% cooler on
ret = SetTemperature(target_temp);
CheckError(ret);
[ret]=CoolerON(); %   Turn on temperature cooler
CheckWarning(ret);

while true
    [ret, temperature] = GetTemperatureF();
    CheckWarning(ret);
    fprintf('The temperature is %f degree C now\n',temperature);
    if ret==20036 % DRV_TEMPERATURE_STABILIZED
        break;
    end
    pause(1);
end

disp('Camera cooling done!');