function ONRMrun(thePath, sName, sNum, testType, scanner, startBlock)

if nargin == 0
    error('Must specify thePath')
end

if nargin<2
    sName = input('Enter date (e.g. ''13Feb09'') ','s');
end

if nargin<3
    sNum = input('Enter subject number: ');
end

if nargin<4
    testType = 0;
    while ~ismember(testType,1:5)
        testType = input('Which task?  Rest[1] SFOLoc[2] ON_S[3] ON_T[4] CPLoc[5] ? ');
    end
end

if nargin<5
    S.scanner = 0;
    while ~ismember(S.scanner,[1:3])
        S.scanner = input('In scanner [1] behavioral [2] or mock scanner [3]? ');
    end
else
    S.scanner = scanner;
end

if nargin<6
    S.startBlock = 0;
    while ~ismember(S.startBlock,[1:6])
        S.startBlock = input('At which block would you like to start?  ');
    end
else
    S.startBlock = startBlock;
end

S.subData = fullfile(thePath.data, [sName '_' num2str(sNum)]);
if ~exist(S.subData)
   mkdir(S.subData); 
end

% Set input device (keyboard or buttonbox)
if S.scanner == 1
    [S.boxNum, S.boxType] = AG3getBoxNumber;  % buttonbox
    S.kbNum = AG3getKeyboardNumber; % keyboard
elseif S.scanner == 3 % Mock scanner
    [S.boxNum, S.boxType] = AG3getBoxNumber;  % buttonbox
    S.kbNum = AG3getKeyboardNumber; % keyboard
else
    S.boxNum = AG3getKeyboardNumber;  % buttonbox
    S.kbNum = AG3getKeyboardNumber; % keyboard
end

%   Condition numbers
S.confScaleNum = 2-mod(sNum,2); % 1 2 1 2
S.encHandNum = 2 - mod(ceil(sNum/2),2); % 1 1 2 2 1 1 2 2

handsToTonesSet = {[1 2 3] [1 3 2] [2 1 3] [2 3 1] [3 1 2] [3 2 1]};
S.handsToTones = handsToTonesSet{1+mod(sNum-1,6)};

%-------------------------------
HideCursor;

% Screen commands
S.screenNumber = max(Screen('Screens'));
S.screenColor = 255;
S.textColor = 0;
S.responseBarColor = [0 0 255];
S.blinkColor  = [0 0 0];
[S.Window, S.myRect] = Screen(S.screenNumber, 'OpenWindow', S.screenColor, [], 32);
Screen('TextSize', S.Window, 30);
Screen('TextStyle', S.Window, 1);
S.on = 1;  % Screen now on
S.scrsz = Screen('Resolution', S.screenNumber);



%% info for test script
S.ResponseRectIns = [S.scrsz.width/2 - 250, S.scrsz.height/2+50, S.scrsz.width/2 + 250,  S.scrsz.height/2+550];
S.MaskingRectIns = [S.scrsz.width/2 - 260, S.scrsz.height/2+300, S.scrsz.width/2 + 260,  S.scrsz.height/2+550];

S.ResponseRect = [S.scrsz.width/2 - 250, S.scrsz.height/2-150, S.scrsz.width/2 + 250,  S.scrsz.height/2+350];
S.MaskingRect = [S.scrsz.width/2 - 260, S.scrsz.height/2+100, S.scrsz.width/2 + 260,  S.scrsz.height/2+350];
    
S.responseCenter = [S.scrsz.width/2 S.scrsz.height/2 + 100];
S.responseRad = 250;
S.respBarThickness = 10;

S.respTextInsLeft = [S.scrsz.width/2 - 280, S.scrsz.height/2+320];
S.respTextInsRight = [S.scrsz.width/2 + 215, S.scrsz.height/2+320];

S.respTextLeft = [S.scrsz.width/2 - 280, S.scrsz.height/2+120];
S.respTextRight = [S.scrsz.width/2 + 215, S.scrsz.height/2+120];
S.respStimY = S.scrsz.height/2+150;

%% hexagons for center/periphery localizer
S.picRad1 = 150;
S.picRad2 = 180;
radDiff = S.picRad2 - S.picRad1;

%mid right
S.hex{1} = [S.scrsz.width/2 + S.picRad2, S.scrsz.height/2 - S.picRad1, S.scrsz.width/2 + S.picRad2+2*S.picRad1,  S.scrsz.height/2+S.picRad1];

% mid left
S.hex{2} = [S.scrsz.width/2 - S.picRad2 - 2*S.picRad1, S.scrsz.height/2 - S.picRad1, S.scrsz.width/2 - S.picRad2,  S.scrsz.height/2+S.picRad1];

% bottom right
S.hex{3} = [S.scrsz.width/2 + radDiff, S.scrsz.height/2 + S.picRad2, S.scrsz.width/2 + 2*S.picRad1 + radDiff,  S.scrsz.height/2 + S.picRad2 + 2*S.picRad1];

% bottom left
S.hex{4} = [S.scrsz.width/2 - 2*S.picRad1 - radDiff, S.scrsz.height/2 + S.picRad2, S.scrsz.width/2 - radDiff,  S.scrsz.height/ 2+ S.picRad2 + 2*S.picRad1];

% top right
S.hex{5} = [S.scrsz.width/2 + radDiff, S.scrsz.height/2 - S.picRad2 - 2*S.picRad1, S.scrsz.width/2 + 2*S.picRad1+ radDiff,  S.scrsz.height/2-S.picRad2];

% top left
S.hex{6} = [S.scrsz.width/2 - 2*S.picRad1 - radDiff, S.scrsz.height/2 - 2*S.picRad1 - S.picRad2, S.scrsz.width/2 - radDiff,  S.scrsz.height/2-S.picRad2];

%%
S.sNum = sNum;
S.sName = sName;

if testType == 1
    saveName = ['ON_rest' sName '_' num2str(sNum) '.mat'];
    
    restData(1) = ON_rest(S);
    
    checkEmpty = isempty(dir (saveName));
    suffix = 1;
    
    while checkEmpty ~=1
        suffix = suffix+1;
        saveName = ['ONRest' sName '_' num2str(sNum) '(' num2str(suffix) ')' '.mat'];
        checkEmpty = isempty(dir (saveName));
    end
    
    eval(['save ' fullfile(S.subData, saveName)]);
            
elseif testType == 2
    saveName = ['ONRMLoc' sName '_' num2str(sNum) '.mat'];
    
    listName = sprintf('SFOLocList_%g.mat', 1+mod(sNum-1, 16));
    SFOLocDat(1) = SFO_Localizer(thePath,listName,sName,sNum,S,1, 1);
    
    checkEmpty = isempty(dir (saveName));
    suffix = 1;
    while checkEmpty ~=1
        suffix = suffix+1;
        saveName = ['SFOLoc_' sName '_' num2str(sNum) '(' num2str(suffix) ')' '.mat'];
        checkEmpty = isempty(dir (saveName));
    end
    
    save(fullfile(S.subData, saveName));
    
elseif testType == 3
    saveName = ['ONRMStudy' sName '_' num2str(sNum) '.mat'];
      
    listName = sprintf('300_Study_PicList_%g.mat', 1+mod(sNum-1, 16));
    studyDat(1) = ON_picStudy(thePath,listName,sName,sNum,S,1, 1);
    
    checkEmpty = isempty(dir (saveName));
    suffix = 1;    
    while checkEmpty ~=1
        suffix = suffix+1;
        saveName = ['ONStudy_' sName '_' num2str(sNum) '(' num2str(suffix) ')' '.mat'];
        checkEmpty = isempty(dir (saveName));
    end

    save(fullfile(S.subData, saveName));
   
elseif testType == 4
    saveName = ['ONRMTest' sName '_' num2str(sNum) '.mat'];

    listName = ['600_Test_PicList_' num2str(mod(sNum,16)) '_' num2str(1) '.mat'];
    ONTestData(1) = ON_picTest(thePath,listName,sName,sNum,1, S);

    checkEmpty = isempty(dir (saveName));
    suffix = 1;

    while checkEmpty ~=1
        suffix = suffix+1;
        saveName = ['ONTest_' sName '_' num2str(sNum) '(' num2str(suffix) ')' '.mat'];
        checkEmpty = isempty(dir (saveName));
    end

    eval(['save ' fullfile(S.subData, saveName)]);   
elseif testType == 5
    saveName = ['ONRMLoc' sName '_' num2str(sNum) '.mat'];
    
    listName = sprintf('CPLocList_%g.mat', 1+mod(sNum-1, 16));
    CPLocDat(1) = CP_Localizer(thePath,listName,sName,sNum,S,1, 1);
    
    checkEmpty = isempty(dir (saveName));
    suffix = 1;
    while checkEmpty ~=1
        suffix = suffix+1;
        saveName = ['CPLoc_' sName '_' num2str(sNum) '(' num2str(suffix) ')' '.mat'];
        checkEmpty = isempty(dir (saveName));
    end
    
    save(fullfile(S.subData, saveName));
end

message = 'End of script. Press any key to exit.';
[hPos, vPos] = AG3centerText(S.Window,S.screenNumber,message);
Screen(S.Window,'DrawText',message, hPos, vPos, S.textColor);
Screen(S.Window,'Flip');
pause;
Screen('CloseAll');

