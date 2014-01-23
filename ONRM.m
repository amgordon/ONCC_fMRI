
% AG1 script
% This script loads the paths for the experiment, and creates
% the variable thePath in the workspace.

pwd
thePath.start = pwd;

[pathstr,curr_dir,ext] = fileparts(pwd);

thePath.script = fullfile(thePath.start, 'script');
thePath.stim = fullfile(thePath.start, 'stim');
thePath.data = fullfile(thePath.start, 'data');
thePath.list = fullfile(thePath.start, 'list');
% add more dirs above

% Add relevant paths for this experiment
names = fieldnames(thePath);
for f = 1:length(names)
    eval(['addpath(thePath.' names{f} ')']);
    fprintf(['added ' names{f} '\n']);
end
cd(thePath.start);

