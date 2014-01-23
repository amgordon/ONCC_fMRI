y = load('wordListNoAbsCon');
testSessLength = 600;
testTotalLength = 600;
numLists = 8;
numSess = 1;
numItems = 600;

NStudy = numItems/2;


for i = 1:numLists;
    thisShuffleIdx = randperm(testTotalLength);
    wordList_all = y.wordListNoAbsCon(thisShuffleIdx,1);
    
    oldNew_all = [];
    for j = 1:numSess
        oldNew = ceil(randperm(testSessLength)/(numItems/2));
        oldNew(oldNew>2)=0;
        
        wordList = cell(size(oldNew));
        wordList(oldNew>0) = wordList_all(1+(j-1)*numItems:(j)*numItems);
        wordList(oldNew==0) = {'+'};
         
        testList = [wordList' num2cell(oldNew')];
        save (sprintf('600_words_Test_List_Salience_%g_%g', i,j), 'testList' );
        
        % now make the 2nd half of lists, this time switching which is old and which
        % new.
        testList = [wordList' num2cell(mod(3-oldNew',3)) ];
        save (sprintf('600_words_Test_List_Salience_%g_%g', i+numLists, j), 'testList' );
        
        oldNew_all = [oldNew_all oldNew];
        
    end
    
    oldNew_all(oldNew_all==0) = [];
    wordListStudy = wordList_all(oldNew_all==1);
    studyList = Shuffle(wordListStudy);
    
    save (sprintf('300_words_Study_%g', i), 'studyList');
    
    % now make the 2nd half of lists, switching old and new.
    wordListStudy = wordList_all(oldNew_all==2);
    wordListStudy = wordListStudy(p);
    studyList = Shuffle(wordListStudy);
    save (sprintf('300_words_Study_%g', i+numLists), 'studyList');
end