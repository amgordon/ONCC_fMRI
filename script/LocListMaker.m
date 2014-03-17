nReps = 4;
nCycles = 5;
cycleLength = 8;
numLists = 16;
ListTypes = {[1 0 2 0 1 0 3 0] [1 0 3 0 1 0 2 0] [2 0 1 0 3 0 1 0] [3 0 1 0 2 0 1 0]};
nTrials = cycleLength*nReps*nCycles;
fixTrialsToRemove = (nTrials-1):nTrials;

nCPStimsPerCond = 40;
nCPCycles = 10;

cd(thePath.list);
for i=1:numLists
    type = 1+mod(i-1,length(ListTypes));
    thisList = ListTypes{type};
    thisListAllCycles = repmat(thisList,1,nCycles);
    
    imgCond = [];
    for j=1:length(thisListAllCycles)
        thisMB = repmat(thisListAllCycles(j), 1, nReps);
        imgCond = [imgCond thisMB];
    end
    
    % remove final fixation items;
    imgCond(fixTrialsToRemove) = [];
    
    allScenes_h = dir(fullfile(thePath.stim, 'scenes_loc/*.jpg'));
    allFaces_h = dir(fullfile(thePath.stim, 'faces/*.jpg'));
    allObjects_h = dir(fullfile(thePath.stim, 'objects/*.jpg'));
    
    allScenes = Shuffle({allScenes_h.name});
    allFaces = Shuffle({allFaces_h.name});
    allObjects = Shuffle({allObjects_h.name});
    
    imgs = cell(size(imgCond));
    imgs(imgCond==0) = {'blank.jpg'};
    imgs(imgCond==1) = allScenes(1:sum(imgCond==1));
    imgs(imgCond==2) = allFaces(1:sum(imgCond==2));
    imgs(imgCond==3) = allObjects(1:sum(imgCond==3));
    
    locList = [imgs' mat2cellByElem(imgCond)'];

    save (sprintf('SFOLocList_%g', i), 'locList');
    
    %% make cploc list
    CPScenePool = allScenes((sum(imgCond==1)+1):end);
    CPScenes_h = CPScenePool(1:(2*nCPStimsPerCond));
    
    CPCond = [];
    for j=1:(nCPCycles*2)
        thisCond = 2-mod(j+i,2);
        thisMB = [repmat(thisCond,1,nReps), zeros(1,nReps)];
        CPCond = [CPCond thisMB];
    end
    
    CPScenes = cell(size(CPCond));
    CPScenes(CPCond==0) = {'blank.jpg'};
    CPScenes(CPCond~=0) = CPScenes_h;
    
    locList = [CPScenes' mat2cellByElem(CPCond)'];
    save (sprintf('CPLocList_%g', i), 'locList');    
end

    
testSessLength = 600;
testTotalLength = 600;

numSess = 1;
numItems = 600;

d = dir(fullfile(thePath.stim, 'scenes_mem', '*.jpg'));
picNames_h = {d.name};
picNames = picNames_h(1:testTotalLength);

cd (thePath.list);

for i = 1:numLists;
    thisShuffleIdx = randperm(testTotalLength);
    picList_all = picNames(thisShuffleIdx);
    
    oldNew_all = [];
    for j = 1:numSess
        oldNew = ceil(randperm(testSessLength)/(numItems/2));
        oldNew(oldNew>2)=0;
        
        picList = cell(size(oldNew));
        picList(oldNew>0) = picList_all(1+(j-1)*numItems:(j)*numItems);

        testList = [picList' num2cell(oldNew') ];
        save (sprintf('600_Test_PicList_%g_%g', i,j), 'testList' );
        
        % now make the 2nd half of lists, this time switching which is old and which
        % new.
        testList = [picList' num2cell(mod(3-oldNew',3))];
        save (sprintf('600_Test_PicList_%g_%g', i+numLists,j), 'testList' );
        
        oldNew_all = [oldNew_all oldNew];
        
    end
    
    picListStudy = picList_all(oldNew_all==1);
    
    perm = randperm(length(picListStudy));
    picListStudy = picListStudy(perm);
        
    studyList = [picListStudy'];    
    save (sprintf('300_Study_PicList_%g', i), 'studyList');
    
    picListStudy = picList_all(oldNew_all==2);
    picListStudy = picListStudy(perm);
    studyList = [picListStudy'];

    save (sprintf('300_Study_PicList_%g', i+numLists), 'studyList');
end