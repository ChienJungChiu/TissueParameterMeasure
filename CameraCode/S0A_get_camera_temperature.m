%{
Check the temperature of the camera

Benjamin Kao
Last update: 2020/11/11
%}

while true
    [ret, temperature] = GetTemperatureF();
    CheckWarning(ret);
    fprintf('The temperature is %f degree C now\n',temperature);
    if ret==20036 % DRV_TEMPERATURE_STABILIZED
        break;
    end
    pause(1);
end
