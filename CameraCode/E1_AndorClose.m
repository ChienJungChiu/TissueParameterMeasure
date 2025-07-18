%{
Turn off the camera

Benjamin Kao
Last update: 2020/11/11
%}

AndorClose();


function [] = AndorClose()
% Shuts down Andor EMCCD.  Nick Hutzler, 30 November 2014

%Abort any acquisition
[ret]=AbortAcquisition;
% If we try to abort an acquisition when there isn't one, we will get a
% warning, but let's ignore that case since it is not relevant.
if ret ~= 20073
    CheckWarning(ret);
end

%Close shutter
[ret]=SetShutter(1, 2, 1, 1);
CheckWarning(ret);

%Turn off cooler
ret = CoolerOFF;
CheckWarning(ret);

%Shut down
[ret]=AndorShutDown;
CheckWarning(ret);

switch ret
    case 20002
        disp('Andor shutdown was successful')
    case 20075
        disp('Andor shutdown was not successful, because it appears to have been already shutdown')
    otherwise
        disp('Andor shutdown was not successful, see above error codes')
end
end