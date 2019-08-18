
% run the setup file to set the matlab paths and add the relevant folders
% to matlab path ...
% Load config sets, global constants, and associated workspace variables

%current_folder_path = pwd;
% clear all;
% start_setup = strcat(pwd,'\Simulink\SimulinkCommon\start_taxibot_main.m');
% run(start_setup);

% get the model under test
%[modelname_in, modelpath_in] = uigetfile('*.mdl', 'Select model under test');

%modelpath_in = 'C:\Taxi-Demo\';
modelname_in = 'TXB_Context_PCM_Context.mdl'; 

model_ref = [modelname_in];
model_name_split = regexp(modelname_in, '\.', 'split');
model_name = char(model_name_split(1));

load_system(model_ref);

set_param('TXB_Context_PCM_Context/Subsystem/Gain','Gain','1');

trig_blk = find_system(model_name, 'BlockType', 'TriggerPort');
trigblkH = get_param(trig_blk, 'handle');


%guide('TaxiDemo_Start.fig');
%msgEvel = evalin('base','msgBox');
%guide(msgEvel);
%msgbox('HLC application updating. Please wait...');

% 
% for i=1:20
% 	rand_num1 = randi(10);
%     set_param(strcat(model_name,'/FL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/FR'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RR'),'Decimation',num2str(rand_num1));	
%     pause(1);
% 	rand_num1 = randi([10,20]);
% 	set_param(strcat(model_name,'/FL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/FR'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RR'),'Decimation',num2str(rand_num1));	
%     pause(1);
% 	rand_num1 = randi([20,30]);
% 	set_param(strcat(model_name,'/FL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/FR'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RR'),'Decimation',num2str(rand_num1));
%     pause(1);
% 	rand_num1 = randi([30,40]);
% 	set_param(strcat(model_name,'/FL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/FR'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RR'),'Decimation',num2str(rand_num1));
%     pause(1);
% 	rand_num1 = randi([40,50]);
% 	set_param(strcat(model_name,'/FL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/FR'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RR'),'Decimation',num2str(rand_num1));	
%     pause(1);	
%     
% 	rand_num1 = randi([5,10]);    
% 	set_param(strcat(model_name,'/FL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/FR'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RL'),'Decimation',num2str(rand_num1));
% 	set_param(strcat(model_name,'/RR'),'Decimation',num2str(rand_num1));	
%     pause(1);		
% end


% memorize parameters settings for trig block to restore the same later.

% for trignum = 1:length(trig_blk)
%     trigblk_params = get_param(trig_blk(1), 'DialogParameters');
%     for k=1:length(trigblk_params)
%         trigblk_fldnames = fieldnames(trigblk_params{k});
%         trigblk_fldnames = trigblk_fldnames'; 
%         indx = 1;
%         for j=1:length(trigblk_fldnames)
%             param_array(trignum, indx) = trigblk_fldnames(j);
%             param_array(trignum, indx+1) = get_param(trig_blk, char(trigblk_fldnames(j)));
%             indx = indx+2;
%         end
%     end
% end

% while running for whole system, this needs to be commented. 
% delete_block(trig_blk);
% save_system(model_name);

% create test harness for the model under test along with expected outputs
% signals part of the signal builder
[obj] = makeharness_compareresults(model_name);

% simulate the test harness - test data fed into model under test and
% output signals logged
%open_system(model_ref);

% Open Scope blocks
%open_system(strcat(model_name,'/FR Scope'));
%open_system(strcat(model_name,'/FL Scope'));
%open_system(strcat(model_name,'/RL Scope'));
%open_system(strcat(model_name,'/RR Scope'));

% guide('TaxiDemo_Start.fig');
% msgEvel = evalin('base','msgBox');
% guide(msgEvel);
% 
% run('TaxiDemo_Start')

%Open up the Top GUI to show simulation (since harness model has come up so only )
TaxiDemo_Start;

   try
        msgEvel = evalin('base','msgBox');
        delete(msgEvel);
        
        msgBoxObj = msgbox('Model compiling and building in Progress...');
        assignin('base', 'msgBox', msgBoxObj);
   catch
        
   end

obj.runSimAll;

% Generate simulink report for the test harness
% this requires Simulink Report Generator license
% obj.runReport;

% to add the removed trigger block
% for n = 1:length(trig_blk)
%     dst = char(trig_blk(n));
%     addedblk = add_block('built-in/TriggerPort',dst);
% end
% paramN=length(param_array)/2;
% arr_str = '';
% for prop = 1:paramN
%     blk_attrib = char(param_array(2*prop-1));
%     attrib_val = char(param_array(2*prop));
%     arr_str=strcat(blk_attrib,',',attrib_val);
% end
%     set_param(addedblk, sprintf('%s',arr_str),'');
% 
% save_system(model_name);

