function [obj] = makeharness_compareresults(mdl,data,opts)
% makeharness_compareresults: Generate a harness model to compare with
% expected outputs.

%   Copyright 2010-2011 The MathWorks, Inc. 

load_system('simulink')

if ~exist('data','var')
    data = [];
end
if verLessThan('matlab','7.11')
    % sldvharnessopts is supported with R2010b or later.
    if ~exist('opts','var')
        opts.modelRefHarness = false;
    end
    % this is old format
    [harnessModel] = slvnvmakeharness(mdl,data,[],opts.modelRefHarness);
else
    if ~exist('opts','var')
        % use default setting
        opts = slvnvharnessopts();
        % change
%         opts.usedSignalsOnly = true;
    end
    [harnessModel] = slvnvmakeharness(mdl,data,opts);
    
end

   try
        msgEvel = evalin('base','msgBox');
        delete(msgEvel);
        
        msgBoxObj = msgbox('Model compiling and building in Progress...');
        assignin('base', 'msgBox', msgBoxObj);
   catch
        
   end
   
% Set covearge settings off
% set_param('TXB_Context_PCM_Context_harness40.mdl', 'CovHtmlReporting', 'off');
% set_param('TXB_Context_PCM_Context_harness40.mdl', 'CovModelRefEnable', 'off');
% set_param('TXB_Context_PCM_Context_harness40.mdl', 'CovExternalEMLEnable', 'off');

%Open up the Top GUI to show simulation (since harness model has come up so only )
TaxiDemo_Start;
%open_system(harnessModel);
modelName = get_param(bdroot,'Name');
TestUnitN = find_system(modelName,'RegExp','on','Name','Test Unit.*');
TestUnitN=TestUnitN{1};
TestUnitH=get_param(TestUnitN,'Handle');

% save input names to model under test
mdlInPortBlkN= find_system(mdl,'SearchDepth',1,'BlockType','Inport');
mdlInPortBlkH=cell2mat(get_param(mdlInPortBlkN,'Handle'));
for n=1:length(mdlInPortBlkN)
    InpBlkN{n}=get_param(mdlInPortBlkH(n),'Name');
end
%it gives you the name of 
sigBuilN = find_system(modelName,'MaskType','Sigbuilder block');
sigBuilN = sigBuilN{1};

SizeTypeN = find_system(modelName,'Name','Size-Type');
SizeTypeN = SizeTypeN{1};
phSizeType = get_param(SizeTypeN,'PortHandles');


%% Setting for outport
OutPortBlkN= find_system(modelName,'SearchDepth',1,'BlockType','Outport');
OutPortBlkH=cell2mat(get_param(OutPortBlkN,'Handle'));

%longRun = 1

for n=1:length(OutPortBlkN)
    ExpectedOutput{n} = sprintf('Exp_%s',get(OutPortBlkH(n),'Name')); %#ok
    
    % This portion of the code is required to fetch only sample time and
    % also sample times are not used anywhere. So line of code is commented
    % during Integrated Models test
    
    %SmplTime{n} = Simulink.Block.getSampleTimes(OutPortBlkH(n));  
    
    %In case we need to use above code, then use below modified code
    
    %------------
    %This pice of code only for longrun modules

    %if longRun == 1
    %    SmplTime{n} = Simulink.Block.getSampleTimes(OutPortBlkH(n));
 	%longRun = 2
    %else
    %    SmplTime{n} = SmplTime{1}
    %------------
    
end

% create test result file <model under test>_test_results.log
rsltFN = sprintf('%s_Test_Result.log',mdl); 
rsltF = fopen(rsltFN, 'w');
fprintf(rsltF, '                      Test result log for model under test ''%s''\n', mdl);
fprintf(rsltF, '%s\n', '********************************************************************************');

%% Adds expected outputs into SignalBuilder

% memorize number of inputs of the SB
phSigBuil = get_param(sigBuilN,'PortHandles');
Ninput = length(phSigBuil.Outport);

TestInpF = addExpectedOutputToSignalBuilder(sigBuilN,ExpectedOutput,rsltF);

% [inP,outP]=getPortNumRelation(TestUnitN,sfnblockN);

% Delete lines of outport signals of Test Harness Unit
for n=1:length(OutPortBlkN)
    delete_line(modelName,sprintf('%s/%d',get(TestUnitH,'Name'),n),[get(OutPortBlkH(n),'Name') '/1'])
end

% Outport handles of the TestUnit
phSimtmp = get(TestUnitH,'PortHandles');
phSim = phSimtmp.Outport;
% Outport handles of the expected outputs in SignalBuilder block
phExptmp = get_param(sigBuilN,'PortHandles');
phExp = phExptmp.Outport(Ninput+1:end);

for n=1:length(OutPortBlkN)
    % force to set PortName to store names of the Outport blocks.
    % The name will be used in createComparingResults to set Assertion signal name.
    set(phSim(n),'Name',get_param(OutPortBlkN{n},'Name'));
    delete_block(OutPortBlkN{n});
end

% set SignalBuilder's port name as ExpectedOutput Name
for n=1:length(phExp)
    set(phExp(n),'Name',ExpectedOutput{n});
end

[time,data,signame]=signalbuilder(sigBuilN); %#ok

% copy name of SignalBuilder to output line names of SizeType
phSizeType = get_param(SizeTypeN,'PortHandles');
for n=1:length(phSizeType.Outport)
    set(phSizeType.Outport(n),'Name',InpBlkN{n}) ;   
end

% to change the rate transition sample time in SizeType to set to '0.01'
rtBlkN_SizeType = find_system(SizeTypeN,'SearchDepth',1,'BlockType','RateTransition');
rtBlkH_SizeType =  cell2mat(get_param(rtBlkN_SizeType,'Handle'));
for n=1:length(rtBlkH_SizeType)
    set_param(rtBlkH_SizeType(n), 'OutPortSampleTime', '[0.01, 0]');   
end

createComparingResults(modelName,phSim,phExp);
save_system(modelName);

% generate an object to prepare test run and capturing test results
%TestUnitN:dz_harness/Test Unit,rsltF:pointer of xls,TestInpF:xl sheet information 
obj = runCMTDReport(TestUnitN,rsltF,TestInpF);

