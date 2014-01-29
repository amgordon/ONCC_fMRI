
function theData = ON_rest(S)

restTime = 612;

ins_txt{1} =  sprintf('In this phase, you will relax for 10 minutes.  During this time, please keep your eyes open and please fixate on the fixation cross in the center of the screen.');
Screen(S.Window,'FillRect', S.textColor);	% Blank Screen
DrawFormattedText(S.Window, ins_txt{1},'center','center', S.screenColor, 75);
Screen('Flip',S.Window);
AG3getKey('g',S.kbNum);

message = 'Press g to begin!';
[hPos, vPos] = AG3centerText(S.Window,S.screenNumber,message);
Screen(S.Window,'DrawText',message, hPos, vPos, S.screenColor);
Screen(S.Window,'Flip');

if S.scanner==1
    % *** TRIGGER ***
    while 1
        AG3getKey('g',S.kbNum);
        [status, startTime] = AG3startScan; % startTime corresponds to getSecs in startScan
        fprintf('Status = %d\n',status);
        if status == 0  % successful trigger otherwise try again
            break
        else
            message = 'Trigger failed, "g" to retry';
            DrawFormattedText(S.Window,message,'center','center',S.screenColor);
            Screen(S.Window,'Flip');
        end
    end
else
    AG3getKey('g',S.kbNum);
    startTime = GetSecs;
end
Priority(MaxPriority(S.Window));

% Fixation
goTime = restTime;
Screen(S.Window,'FillRect', S.textColor);	% Blank Screen
DrawFormattedText(S.Window,'+','center','center',S.screenColor);
Screen(S.Window,'Flip');

AG3recordKeys(startTime,goTime,S.kbNum);  % not collecting keys, just a delay

theData.totalTime = GetSecs-startTime;


cd(S.subData);

matName = fullfile(S.subData, ['rest_' num2str(sNum), '_date_' sName 'out.mat']);

checkEmpty = isempty(dir (matName));
suffix = 1;

while checkEmpty ~=1
    suffix = suffix+1;
    matName = fullfile(S.subData, ['rest_' num2str(sNum), '_' sName 'out(' num2str(suffix) ').mat']);
    checkEmpty = isempty(dir (matName));
end

cmd = ['save ' matName];
eval(cmd);

Screen(S.Window,'FillRect', S.textColor);	% Blank Screen
Screen(S.Window,'Flip');

% ------------------------------------------------
Priority(0);
