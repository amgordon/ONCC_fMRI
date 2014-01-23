function [ output_args ] = convertPicLists(thePath)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cd(thePath.list)
d = dir('450_Study_PicList*');


condSet = 1:3;
for i=1:length(d);
    dat = load(d(i).name);
    dat.studyList(:,3:4) = [];
    
    prevCond = -1;
    for j=1:450
        thisCond_h = Shuffle(condSet);
        if (thisCond_h(1)==prevCond);
            cond{j} = thisCond_h(2);
        else
            cond{j} = thisCond_h(1);
        end
        prevCond = cond{j};
    end
    
    dat.studyList(:,2) = cond';
    studyList = dat.studyList;
    
    thisFile = strrep(d(i).name, 'PicList', 'PicList_wSoundConds');
    save(thisFile, 'studyList')
end

end

