%
% Start script for main development stream in Taxibot repo
%
%
% $Id: start_taxibot_app.m 4201 2011-12-16 15:41:35Z gfrost $
%
this_file_s = which(mfilename);
main_base_path_s = fileparts(this_file_s);    % identify path to this file

% Add infrastructure paths and global items
run([main_base_path_s '\..\SimulinkCommon\setup_SimulinkCommon']);

% Add paths to load IAI feature interface
disp('Setting up IAI feature interface configuration...');
% This setup is loaded from files outside Ricardo's formal SVN area,
% since they are not files directly under Ricardo's control

%addpath([fileparts(fileparts(main_base_path_s)) '\iai_matlab\arch_temp']);
addpath([fileparts(fileparts(main_base_path_s)) '\Acs\']);

% Run the IAI M2S config files for input interface to Ricardo features
disp('Running IAI config files...');
basedir = pwd;
dirs = dir('..\Acs');
dirs1 = dirs(~(strcmp({dirs.name}, '.') | strcmp({dirs.name}, '..')));
for i = 1:length(dirs1)
    cd (['..\Acs\' dirs1(i).name]);
    addpath(genpath(pwd));
    dir_files = dir('.');
    for j = 1:length(dir_files)
        if ~isempty(strfind(dir_files(j).name,'_config.m'))
            disp(['Running ' dir_files(j).name '...']);
            run([main_base_path_s '\..\Acs\' dirs1(i).name '\' dir_files(j).name]);
        end
    end
    cd (basedir);
end


% Add paths to Ricardo features

current_contexts = {};
context_dirs = dir(pwd);
for i = 1:length(context_dirs)
   if ~isempty(regexp(context_dirs(i).name,'^app*')) && (context_dirs(i).isdir)
   current_contexts{end+1} = context_dirs(i).name;
   end
end
disp('Adding feature directories to path...');
filtered_dirs = {};
for j = 1:length(current_contexts)
%dirs = dir('..\features');
% Add path of main app context
addpath ([main_base_path_s  '\' current_contexts{j}]);
% And its subdirectories (features)
dirs = dir(current_contexts{j});
for i = 1:length(dirs)
    % Run relevant app's config file
    if ~isempty(strfind(dirs(i).name,'_config.m'))
            disp(['Running ' dirs(i).name '...']);
            run([main_base_path_s '\' current_contexts{j} '\' dirs(i).name]);
    end
    % Add to path if it is a feature subdir or other relevant subdir
    if ~strcmp(dirs(i).name, '.') && ~strcmp(dirs(i).name, '..') &&...
            ~strcmp(dirs(i).name, '.svn') &&...
            ~strcmp(dirs(i).name, 'sfprj') &&...
            ~strcmp(dirs(i).name, 'slprj') && (dirs(i).isdir)
        p = [main_base_path_s  '\' current_contexts{j} '\' dirs(i).name];
        %if isdir(p)
        addpath(p);
        filtered_dirs{end+1} = p;
        %end
    end
end
end



disp('Calling feature configuration...')
for i = 1:length(filtered_dirs)
    % Extract feature acronym
    feature_st = regexp(filtered_dirs{i}, '(?<name>\w+)__.*', 'names');
    if ~isempty(feature_st)
        featurename_s = feature_st.name;
        
        % Look for <feature>_config.m file and run if found
        cmd = [featurename_s '_config'];
        if exist([filtered_dirs{i} '\' cmd '.m'])
            run([filtered_dirs{i} '\' cmd]);
        end
        
        % Look for <feature>_dev_config.m file and run if found
        cmd = [featurename_s '_dev_config'];
        if exist([filtered_dirs{i} '\' cmd '.m'])
            run([filtered_dirs{i} '\' cmd]);
        end
    end
end



%define_alias_types;