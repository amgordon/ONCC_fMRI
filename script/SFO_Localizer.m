
function theData = SFO_Localizer(thePath,listName,sName, sNum, S,EncBlock, startTrial)

% theData = AG3encode(thePath,listName,sName,S,startTrial);
% This function accepts a list, then loads the images and runs the expt
% Run AG3.m first, otherwise thePath will be undefined.
% This function is controlled by BH1run
%
% To run this function solo:
% set S.on = 0
% startTrial = 1
% testSub = 'AG'
% theData = AG3retrieve(thePath,'Acc1_encode_7_1.mat','testSub',0,startTrial);

% Read in the list
cd(thePath.list);


list = load(listName);

theData.item = list.locList(:,1);
theData.cond = list.locList(:,2);

listLength = length(theData.item);

scrsz = get(0,'ScreenSize');

% Diagram of trial

stimTime = 3.85;
blankTime = .15;

behLeadinTime = 1;
scanLeadinTime = 12;

Screen(S.Window,'FillRect', S.screenColor);
Screen(S.Window,'Flip');
cd(thePath.stim);


% preallocate:
trialcount = 0;
for preall = startTrial:listLength
        theData.onset(preall) = 0;
        theData.dur(preall) =  0;
        theData.stimResp{preall} = 'noanswer';
        theData.stimRT{preall} = 0;
end

hands = {'Left','Right'};

if S.scanner == 2
    fingers = {'q', 'p'};
elseif S.scanner ==1;
    fingers = {'1!', '5%'};
end

hsn = S.encHandNum;

cd(fullfile(thePath.stim,'allStims'));
for n=1:listLength
    picName = theData.item{n};
    pic = imread(picName);
    picPtrs(n) = Screen('MakeTexture', S.Window, pic);   
    
    pctLoaded = round(100*(n/listLength));
    pctMsg = sprintf('pictures %g percent loaded', pctLoaded);
    DrawFormattedText(S.Window,pctMsg,'center','center',S.textColor);
    Screen(S.Window, 'Flip');
end

% for the first block, display instructions
if EncBlock == 1

    ins_txt{1} =  sprintf('In this phase, you will see a series of pictures presented on the screen.  Between each set of pictures, you will see a blank screen with a fixation cross. \n \n Please pay attention to each picture.  When the screen is blank, please look at the fixation cross.');

    DrawFormattedText(S.Window, ins_txt{1},'center','center',S.textColor, 75);
    Screen('Flip',S.Window);

    AG3getKey('g',S.kbNum);

end

% get ready screen
message = 'Press g to begin!';
[hPos, vPos] = AG3centerText(S.Window,S.screenNumber,message);
Screen(S.Window,'DrawText',message, hPos, vPos, S.textColor);
Screen(S.Window,'Flip');

% give the output file a unique name
cd(S.subData);

matName = ['Loc_sub' num2str(sNum), '_date_' sName 'out.mat'];

checkEmpty = isempty(dir (matName));
suffix = 1;

while checkEmpty ~=1
    suffix = suffix+1;
    matName = ['Loc_sub' num2str(sNum), '_date_' sName 'out_' num2str(suffix)  '.mat'];
    checkEmpty = isempty(dir (matName));
end

matName = fullfile(S.subData,matName);

% Present test trials
goTime = 0;

%  initiate experiment and begin recording time...
% start timing/trigger

if S.scanner==1
    % *** TRIGGER ***
    while 1
        AG3getKey('g',S.kbNum);
        [status, startTime] = AG3startScan; % startTime corresponds to getSecs in startScan
        fprintf('Status = %d\n',status);
        if status == 0  % successful trigger otherwise try again
            break
        else
            Screen(S.Window,'DrawTexture',blank);
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
if S.scanner == 1
    goTime = goTime + scanLeadinTime;
elseif S.scanner ==2;
    goTime = goTime + behLeadinTime;
end
Screen(S.Window,'Flip');
AG3recordKeys(startTime,goTime,S.kbNum);  % not collecting keys, just a delay
baselineTime = GetSecs;


for Trial = 1:listLength
    trialcount = trialcount + 1;
    
    ons_start = GetSecs;
    
    theData.onset(Trial) = GetSecs - startTime; %precise onset of trial presentation
    
    % Stim
    goTime = stimTime;
    theData.stimTime(Trial) = GetSecs;
    
    if theData.cond{Trial}~=0
        Screen('DrawTexture', S.Window, picPtrs(Trial));
        Screen(S.Window,'Flip');
        [keys, RT] = AG3recordKeys(ons_start,goTime,S.boxNum);
        
        % Desired Time
        desiredTime = (Trial)*(stimTime + blankTime);
        curTime = GetSecs - baselineTime;
        goTime = goTime + desiredTime - curTime - 1/120;
        Screen(S.Window,'Flip');
        AG3recordKeys(ons_start,goTime,S.boxNum);
    else
        DrawFormattedText(S.Window,'+','center','center',S.textColor);
        Screen(S.Window,'Flip');
        AG3recordKeys(ons_start,goTime,S.boxNum);
        
        % Desired Time
        desiredTime = (Trial)*(stimTime + blankTime);
        curTime = GetSecs - baselineTime;
        goTime = goTime + desiredTime - curTime - 1/120;
        DrawFormattedText(S.Window,'+','center','center',S.textColor);
        Screen(S.Window,'Flip');
        AG3recordKeys(ons_start,goTime,S.boxNum);
    end
    
    
    theData.stimResp{Trial} = keys;
    theData.stimRT{Trial} = RT;
    
    cmd = ['save ' matName];
    eval(cmd);
    fprintf('%d\n',Trial);
end

fprintf(['/nExpected time: ' num2str(goTime)]);
fprintf(['/nActual time: ' num2str(GetSecs-startTime)]);


cmd = ['save ' matName];
eval(cmd);


Screen(S.Window,'FillRect', S.screenColor);	% Blank Screen
Screen(S.Window,'Flip');

% ------------------------------------------------
Priority(0);
