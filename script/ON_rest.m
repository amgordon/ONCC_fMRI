
function theData = ON_rest(S)

restTime = 612;

ins_txt{1} =  sprintf('During this phase, you will relax for 10 minutes.  During this time, please keep your eyes open and please fixate on the fixation cross in the center of the screen.');
DrawFormattedText(S.Window, ins_txt{1},'center','center', S.textColor, 75);
Screen('Flip',S.Window);
AG3getKey('g',S.kbNum);

message = 'Press g to begin!';
[hPos, vPos] = AG3centerText(S.Window,S.screenNumber,message);
Screen(S.Window,'DrawText',message, hPos, vPos, S.textColor);
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
            DrawFormattedText(S.Window,message,'center','center',S.textColor);
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
Screen(S.Window,'FillRect', S.screenColor);	% Blank Screen
DrawFormattedText(S.Window,'+','center','center',S.textColor);
Screen(S.Window,'Flip');

AG3recordKeys(startTime,goTime,S.kbNum);  % not collecting keys, just a delay

theData.totalTime = GetSecs-startTime;

cd(S.subData);
matName = ['Rest_' num2str(S.sNum), '_' S.sName 'out(1).mat'];
cmd = ['save ' matName];
eval(cmd);

Screen(S.Window,'FillRect', S.screenColor);	% Blank Screen
Screen(S.Window,'Flip');

% ------------------------------------------------
Priority(0);
