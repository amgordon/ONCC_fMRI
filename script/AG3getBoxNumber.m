
function [deviceNumber boxType] = AG3getBoxNumber

% Checks the connected USB devices and returns the deviceNumber corresponding
% to the button box we use in the scanner. 
% JC 03/02/06
% AG 09/01/11

deviceNumber = 0;
d = PsychHID('Devices');
deviceNumber = [];
for n = 1:length(d)
    if (strcmp (d(n).usageName, 'Keyboard') &&(d(n).productID ~=560))
    deviceNumber = [deviceNumber n];
    %if (d(n).productID == 8) && (strcmp(d(n).usageName,'Keyboard')) %CNI, 10-button button boxes
    %if (d(n).productID == 612) && (strcmp(d(n).usageName,'Keyboard')) %CNI, hand-shaped button boxes
    %if (d(n).productID == 560) && (strcmp(d(n).usageName,'Keyboard')) %Recca
    %if (d(n).productID ==33346 && (strcmp(d(n).usageName,'Keyboard')) %%mock scanner
    end
end

if isempty(deviceNumber)
    user_terminate = input(['\n Button box NOT FOUND. Press zero to terminate script. \n']);
    if user_terminate==0
        sca;
        error('Button Box NOT FOUND.')
    end
end

if length(deviceNumber) > 1
    for i = 1:length(deviceNumber)
        fprintf('\n deviceNumber %g detected', deviceNumber(i));
    end    
    user_box_spec = input(['\n Multiple eligible button boxes found.  \n Enter which device you would like to use, or press zero to terminate script. \n']);
    if user_box_spec==0
        sca;
        error('Button Box NOT FOUND.')   
    else
        deviceNumber = user_box_spec;
    end
end


if(d(deviceNumber).productID==612)
    boxType = 'handBox';
elseif(d(deviceNumber).productID==8)
    boxType = 'squareBox';
else
    boxType = 'unknown';
end