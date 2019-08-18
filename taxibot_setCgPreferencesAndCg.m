function taxibot_setCgPreferencesAndCg()
% taxibot_setCgPreferences - Sets Code Generation Preferences  for use on TaxiBot project

% $Id: @(#) taxibot_setCgPreferencesAndCg.m@@\main\PrototypeNB_Integration\PrototypeNB_Blk2_Integ\PrototypeNB_Blk2_6.6.4.1_Integ\TXB_NB_Integration\1  2014-06-22 11:50:26 GMT  scolombu $

% Find the path of the base 'taxibot' SVN directory

disp('**********************************************************************');
disp(['Executing TaxiBot setCgPreferences file: ',which(mfilename)]);
disp('$Id: @(#) taxibot_setCgPreferencesAndCg.m@@\main\PrototypeNB_Integration\PrototypeNB_Blk2_Integ\PrototypeNB_Blk2_6.6.4.1_Integ\TXB_NB_Integration\1  2014-06-22 11:50:26 GMT  scolombu $');
disp('**********************************************************************');

this_file_s = which(mfilename);
base_path_s = fileparts(this_file_s);    % sandbox software directory <taxibot sandbox>/
assignin('base', 'base_path_s', base_path_s);

rootPathCodeGen = 'C:\TaxibotTempCG\';
folderCodeGen = '';
modelName = '';

% *************************************************************************
%  Provide choice of project:
% *************************************************************************

project_strings = {...
    'Taxibot acM2S',...
    'Taxibot ahrsM2S',...
    'Taxibot alnM2S',...
    'Taxibot atcM2S',...
    'Taxibot bswM2S',...
    'Taxibot csM2S',...
    'Taxibot dcM2S',...
    'Taxibot dfM2S',...
    'Taxibot dgpsM2S',...
    'Taxibot dpM2S',...
    'Taxibot dpvM2S',...
    'Taxibot intcM2S',...
    'Taxibot isM2S',...
    'Taxibot lvcM2S',...
    'Taxibot ltM2S',...
    'Taxibot mdM2S',...
    'Taxibot pduM2S',...    
    'Taxibot swM2S',...
    'Taxibot tasM2S',...
    'Taxibot vlM2S',...
    'Taxibot wmlM2S',...
    'Taxibot yrsM2S',...
    'Taxibot locTrF',...    
    'Taxibot locTrS',...    
    'Taxibot moTrF',...    
    'Taxibot moTrS',...    
    'Taxibot db2sp',...    
    'Taxibot safety',...    
    'Taxibot healthMonitor',...
    'Taxibot modeManager',...
    'Taxibot engineManager',...
    'Taxibot missionOperation',...
    'Taxibot Localization',...
    'Taxibot LocDataPrep',...
    'Taxibot Ricardo DamperControl',...
    'Taxibot Ricardo DemandControl',...
    'Taxibot Ricardo ForceControl',...
    'Taxibot Ricardo SteeringControl',...
    'Taxibot SteeringwheelBreak',...
    'Taxibot YawRateFilter',...
    'Taxibot All Models'...
    'Exit'
    };

folderCodeGenString = {...
    'Acs\acsAcM2S\',...
    'Acs\acsAhrsM2S\',...
    'Acs\acsAlnM2S\',...
    'Acs\acsAtcM2S\',...
    'Acs\acsBswM2S\',...
    'Acs\acsCsM2S\',...
    'Acs\acsDcM2S\',...
    'Acs\acsDfM2S\',...
    'Acs\acsDgpsM2S\',...
    'Acs\acsDpM2S\',...
    'Acs\acsDpvM2S\',...
    'Acs\acsIntcM2S\',...
    'Acs\acsIsM2S\',...
    'Acs\acsLvcM2S\',...
    'Acs\acsLtM2S\',...
    'Acs\acsMdM2S\',...
    'Acs\acsPduM2S\',...
    'Acs\acsSwM2S\',...
    'Acs\acsTasM2S\',...
    'Acs\acsVlM2S\',...
    'Acs\acsWmlM2S\',...
    'Acs\acsYrsM2S\',...
    'Acs\acsLocTrF\',...
    'Acs\acsLocTrS\',...
    'Acs\acsMoTrF\',...
    'Acs\acsMoTrS\',...
    'Acs\acsDb2Sp\',...
    'App\appSafetyModule\',...
    'App\appHealthMonitor\',...
    'App\appModeManager\',...
    'App\appEngineManager\',...
    'App\appMissionOperation\',...
    'App\appLocalization\',...
    'App\appLocDataPrep\',...
    'App\appDamperControl\',...
    'App\appDemandManagement\',...
    'App\appForceControl\',...
    'App\appSteeringControl\',...
    'App\appSteeringwheelBreak\',...
    'App\appYawRateFilter\'
    };

modelNameString = {...
    'acM2S',...
    'ahrsM2S',...
    'alnM2S',...
    'atcM2S',...
    'bswM2S',...
    'csM2S',...
    'dcM2S',...
    'dfM2S',...
    'dgpsM2S',...
    'dpM2S',...
    'dpvM2S',...
    'intcM2S',...
    'isM2S',...
    'lvcM2S',...
    'ltM2S',...
    'mdM2S',...
    'pduM2S',...
    'swM2S',...
    'tasM2S',...
    'vlM2S',...
    'wmlM2S',...
    'yrsM2S',...
    'locTrFast_context',...
    'locTrSlow_context',...
    'moTrFast_context',...
    'moTrSlow_context',...
    'db2sp_context',...
    'sm_context',...
    'hm_context',...
    'mm_context',...
    'em_context',...
    'mo_context',...
    'loc_context',...
    'locDataPrep_context',...
    'damper_control_context',...
    'demand_management_context',...
    'force_control_context',...
    'steering_control_context',...
    'sb_context',...
    'yrf_context'
    };
while 1
    [project_selection, answer] = listdlg(...
        'Name', 'Project Selector', ...
        'PromptString', 'Select project...', ...
        'ListString', project_strings, ...
        'ListSize', [300 650], ...
        'SelectionMode', 'single', ...
        'OKString', 'Select', ...
        'CancelString', 'Exit', 'uh', 25);
    
    if answer ~= 0
        projectstr = char(project_strings(project_selection));
        
        if  strcmp(projectstr, 'Exit')
            break;
        else
            
            if  strcmp(projectstr, 'Taxibot All Models')
                
                
                for ii = 1:length(folderCodeGenString)
                    projectstr1 = char(project_strings{ii});
                    disp(['Setting preferences for project: ' projectstr]);
                    
                    folderCodeGen = char(folderCodeGenString{ii});
                    modelName = char(modelNameString{ii});
                    
                    if   exist([rootPathCodeGen, folderCodeGen])
                        disp(['CMD: delete '  rootPathCodeGen, folderCodeGen]);
                        
                        list_folderCodeGen = dir([rootPathCodeGen, folderCodeGen]);
                        system(['del '  rootPathCodeGen, folderCodeGen, ' -r *.* /s /f /q' ]);
                        
                        for ll = 1:length(list_folderCodeGen)
                            if ~strcmp(list_folderCodeGen(ll).name, '.') && ~strcmp(list_folderCodeGen(ll).name, '..')
                                currName = char(list_folderCodeGen(ll).name);
                                if isdir([rootPathCodeGen folderCodeGen currName])
                                    % Remove it to the context model level in informal_code
                                    system(['rmdir '  rootPathCodeGen, folderCodeGen, currName, ' /s /q' ]);
                                    disp('');
                                end
                            end
                        end
                    end
                    
                    set_param(0,'CodeGenFolder',[rootPathCodeGen, folderCodeGen]);
                    set_param(0,'CacheFolder',[rootPathCodeGen, folderCodeGen]);
                    
                    try
                        rtwbuild(modelName);
                    catch
                        disp(['error while code generation of ', modelName]);
                    end
                end
                
            else
                switch projectstr
                    
                    case 'Taxibot acM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsAcM2S\';
                        modelName = 'acM2S';
                        
                    case 'Taxibot ahrsM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsAhrsM2S\';
                        modelName = 'ahrsM2S';
                        
                    case 'Taxibot alnM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsAlnM2S\';
                        modelName = 'alnM2S';
                        
                    case 'Taxibot atcM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsAtcM2S\';
                        modelName = 'atcM2S';
                        
                    case 'Taxibot bswM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsBswM2S\';
                        modelName = 'bswM2S';
                        
                    case 'Taxibot csM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsCsM2S\';
                        modelName = 'csM2S';
                        
                    case 'Taxibot dcM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsDcM2S\';
                        modelName = 'dcM2S';
                        
                    case 'Taxibot dfM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsDfM2S\';
                        modelName = 'dfM2S';
                        
                    case 'Taxibot dgpsM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsDgpsM2S\';
                        modelName = 'dgpsM2S';
                        
                    case 'Taxibot dpM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsDpM2S\';
                        modelName = 'dpM2S';
                        
                    case 'Taxibot dpvM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsDpvM2S\';
                        modelName = 'dpvM2S';
                        
                    case 'Taxibot intcM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsIntcM2S\';
                        modelName = 'intcM2S';
                        
                    case 'Taxibot isM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsIsM2S\';
                        modelName = 'isM2S';
                        
                    case 'Taxibot lvcM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsLvcM2S\';
                        modelName = 'lvcM2S';
                        
                    case 'Taxibot ltM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsLtM2S\';
                        modelName = 'ltM2S';
                        
                    case 'Taxibot mdM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsMdM2S\';
                        modelName = 'mdM2S';
                        
                    case 'Taxibot pduM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsPduM2S\';
                        modelName = 'pduM2S';
                        
                    case 'Taxibot swM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsSwM2S\';
                        modelName = 'swM2S';
                        
                    case 'Taxibot tasM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsTasM2S\';
                        modelName = 'tasM2S';
                        
                    case 'Taxibot vlM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsVlM2S\';
                        modelName = 'vlM2S';
                        
                    case 'Taxibot wmlM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsWmlM2S\';
                        modelName = 'wmlM2S';
                        
                    case 'Taxibot yrsM2S'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsYrsM2S\';
                        modelName = 'yrsM2S';
 
                    case 'Taxibot locTrF'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsLocTrF\';
                        modelName = 'locTrFast_context';
                        
                    case 'Taxibot locTrS'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsLocTrS\';
                        modelName = 'locTrSlow_context';
                        
                    case 'Taxibot moTrF'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsMoTrF\';
                        modelName = 'moTrFast_context';
                        
                    case 'Taxibot moTrS'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsMoTrS\';
                        modelName = 'moTrSlow_context';
                        
                    case 'Taxibot db2sp'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'Acs\acsDb2Sp\';
                        modelName = 'db2sp_context';
                        
                    case 'Taxibot safety'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appSafetyModule\';
                        modelName = 'sm_context';
                        
                    case 'Taxibot healthMonitor'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appHealthMonitor\';
                        modelName = 'hm_context';
                        
                    case 'Taxibot modeManager'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appModeManager\';
                        modelName = 'mm_context';
                        
                     case 'Taxibot engineManager'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appEngineManager\';
                        modelName = 'em_context';
                        
                   case 'Taxibot missionOperation'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appMissionOperation\';
                        modelName = 'mo_context';
                        
                    case 'Taxibot Localization'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appLocalization\';
                        modelName = 'loc_context';
                        
                    case 'Taxibot Ricardo DamperControl'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appDamperControl\';
                        modelName = 'damper_control_context';
                        
                    case 'Taxibot Ricardo DemandControl'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appDemandManagement\';
                        modelName = 'demand_management_context';
                        
                    case 'Taxibot Ricardo ForceControl'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appForceControl\';
                        modelName = 'force_control_context';
                        
                    case 'Taxibot Ricardo SteeringControl'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appSteeringControl\';
                        modelName = 'steering_control_context';
                        
                    case 'Taxibot SteeringwheelBreak'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appSteeringwheelBreak\';
                        modelName = 'sb_context';
                        
                     case 'Taxibot YawRateFilter'
                        disp(['Setting paths for project: ' projectstr]);
                        
                        folderCodeGen = 'App\appYawRateFilter\';
                        modelName = 'yrf_context';
                        
                       
                    otherwise
                        warning('Unknown project selection');
                end
                
                if  ~strcmp(folderCodeGen, '') && ~strcmp(modelName, '')
                    if   exist([rootPathCodeGen, folderCodeGen])
                        disp(['CMD: delete '  rootPathCodeGen, folderCodeGen]);
                        
                        list_folderCodeGen = dir([rootPathCodeGen, folderCodeGen]);
                        system(['del '  rootPathCodeGen, folderCodeGen, ' -r *.* /s /f /q' ]);
                        
                        for ii = 1:length(list_folderCodeGen)
                            if ~strcmp(list_folderCodeGen(ii).name, '.') && ~strcmp(list_folderCodeGen(ii).name, '..')
                                currName = char(list_folderCodeGen(ii).name);
                                if isdir([rootPathCodeGen folderCodeGen currName])
                                    % Remove it to the context model level in informal_code
                                    system(['rmdir '  rootPathCodeGen, folderCodeGen, currName, ' /s /q' ]);
                                    disp('');
                                end
                            end
                        end
                    end
                    
                    set_param(0,'CodeGenFolder',[rootPathCodeGen, folderCodeGen]);
                    set_param(0,'CacheFolder',[rootPathCodeGen, folderCodeGen]);
                    
                    try
                        rtwbuild(modelName);
                    catch
                        disp(['error while code generation of ', modelName]);
                    end
                    rmpath([rootPathCodeGen, folderCodeGen]);
                end
            end
        end
        rmpath([rootPathCodeGen, folderCodeGen]);
    end
end
return
