
testSessLength = 600;
testTotalLength = 600;
numLists = 8;
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