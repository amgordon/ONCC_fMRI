function [ ] = RMListMaker()

nSess = 2;
nListIts = 16;
nTrialsEachMod = 24;
nTrialsFix = 16;


for n = 1:nListIts
    for s = 1:nSess
        stims_h = [ones(1, nTrialsEachMod) 2*ones(1, nTrialsEachMod) 0*ones(1, nTrialsFix)];
        
        oldNew_h = [ones(1, nTrialsEachMod/2) 2*ones(1, nTrialsEachMod/2) ...
            ones(1, nTrialsEachMod/2) 2*ones(1, nTrialsEachMod/2) 0*ones(1, nTrialsFix)];
        
        conf_h = [ones(1, nTrialsEachMod/2) 2*ones(1, nTrialsEachMod/2) ...
            2*ones(1, nTrialsEachMod/2) ones(1, nTrialsEachMod/2) 0*ones(1, nTrialsFix)];
 
        
        [stims shuffIdx] = Shuffle(stims_h);
        oldNew = oldNew_h(shuffIdx);
        conf = conf_h(shuffIdx);
        
        RMList = [stims' oldNew' conf'] ;
        save (sprintf('RM_List_%g_%g', n, s), 'RMList' );
    end
end

end

