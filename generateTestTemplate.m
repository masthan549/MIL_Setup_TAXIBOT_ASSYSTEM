% m-script to generate a test input template file given a model file
% Static header is written into a template populates test inputs from a 
% test harness signal builder outports and also appends output ports of 
% the test model prefixing 'Exp_'.

%clear all
% load simulink env
load_system('simulink')
% run the setup file to set the matlab paths and add the relevant folders
% to matlab path ...
% Load config sets, global constants, and associated workspace variables
%run('C:\Palani\Simulink\App\start_taxibot_app.m');
% get model under test
[modelname_in, modelpath_in] = uigetfile('*.mdl', 'Select model under test');
% format model name
model_ref = [modelpath_in modelname_in];
model_name_split = regexp(modelname_in, '\.', 'split');
model_name = char(model_name_split(1));
% open test model to generate test harness
%open_system(model_name);
% generate test harness
[harnessPathFile] = slvnvmakeharness(model_name);
% find singnal builder block in the test harness
modelName = get_param(bdroot,'Name');
sigBuilN = find_system(modelName,'MaskType','Sigbuilder block');
sigBuilN = sigBuilN{1};
% get signal builder block output signals
[time,data,sign,grpn] = signalbuilder(sigBuilN);
%get output signals of the model under test
OutPortBlkN= find_system(modelName,'SearchDepth',1,'BlockType','Outport');
OutPortBlkH=cell2mat(get_param(OutPortBlkN,'Handle'));
% prefix output signals with 'Exp_' as expected output signals
for n=1:length(OutPortBlkN)
    output{n}= get(OutPortBlkH(n),'Name');
    ExpectedOutput{n} = sprintf('Exp_%s',output{n}); 
end
% prepare data array to write in as a test template
tempArr = {'Test Procedure Identifier','TXB-HLC/TP/xxxx',''; 'Test description', '','';'Version', '','';'Author', '','';'','','';'Step','Time(ms)','Type'};
% append input singal names
for i=1:length(sign)
    tempArr(6,end+1)=sign(i);
end
% append expected output singal names
for i=1:length(ExpectedOutput)
    tempArr(6,end+1)=ExpectedOutput(i);
end

% write into a Excel Spread Sheet with name <model_under_test>_Template.xls
tempFile = sprintf('%s_Template.xls', model_name);
xlswrite(tempFile, tempArr, 'Test template');

% to write signal details
dataDictArr = [];
signNotinWS = [];
dataDictArr = {'Signal Name', 'Signal Description', 'Signal DataType', 'Signal Units', 'Signal Min Value', 'Signal Max Value', 'Signal Initial Value'};
allSignals = [sign output];
for i=1:length(allSignals)
    s2 = regexp(allSignals{i}, '\.', 'split');
    if length(s2) > 1
        sigN = s2(2);
    else
        sigN = allSignals{i};
    end
    sigN=char(sigN);
    sigN_exists = exist(sigN);
    if sigN_exists
        sigNobj = eval(sigN);
        dataDictArr(i+2,:) = { sigN, sigNobj.Description, sigNobj.DataType, sigNobj.DocUnits, sigNobj.Min, sigNobj.Max, sigNobj.InitialValue};
    else
        signNotinWS{end+1} = sigN;
    end
end
for k=1:length(signNotinWS)
    dataDictArr(end+1,:) = {signNotinWS(k), 'Signal not available in base workspace. Look for the signal details other relevant docs.','','','','',''};
end
    
xlswrite(tempFile, dataDictArr, 'Signal Data Details');
