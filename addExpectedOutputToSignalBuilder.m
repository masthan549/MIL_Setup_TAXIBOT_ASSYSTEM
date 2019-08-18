function [XlsFile] = addExpectedOutputToSignalBuilder(blk,sigName,rsltF)
% addExpectedOutputToSignalBuilder  add Signals into existing SignalBuilder
% 
% This function adds signals into specified SignalBuilder block
% This function also uses user test data to build SignalBuilder block
% input:
%  blk: Block path to SignalBuilder block
%  sigName: A cell array of signal names to be added.

%   Copyright 2010-2011 The MathWorks, Inc. 

%% Retain exising line connection and delete lines
lh = get_param(blk,'LineHandles');
for n=1:length(lh.Outport)
    lineDst{n} = sprintf('%s/%d',get(lh.Outport(n),'DstBlock'),get(get(lh.Outport(n),'DstPortHandle'),'PortNumber'));
end

for n=1:length(lh.Outport)
    delete_line(lh.Outport(n));
end

% obtain existing time, data, and signal names and delete it.
[time,data,sign,grpn] = signalbuilder(blk);

% to access model fixed step setting - model base sample time
% myConfigObj = getActiveConfigSet(gcs);
% solverSettings = myConfigObj.getComponent('Solver');
% fixedStepT = solverSettings.FixedStep;
% baseSampleTs = evalin('base', base_sample_time)


for n=1:length(sigName)
    time(end+1,1) = time(1,1);
    data(end+1,1) = data(1,1);
    sign{end+1} = sigName{n};
end

pos = get_param(blk,'Position');
% pos(4) = pos(4) + 20*length(sigName);
pos(4) = pos(4) + 50*length(sigName);
delete_block(blk);

% read test data from excel sheet and add the same to signal builder block.
%[XlsFile,] = uigetfile('*.xlsx','select data file');
[XlsFile,] = 'TaxibotDemo_PCM_Template_5.xlsx';
if isequal(XlsFile,0)
    return
end

% Log test case file name info into the test result log
fprintf(rsltF, 'Test case Input file: %s\n', char(XlsFile));

% Get Excel file sheet information
[~,TestCases] = xlsfinfo(XlsFile);

% log the test header and description info
[~,Text]=xlsread(XlsFile,TestCases{1});
docTextsize=size(Text,1)-1;
for n=1:docTextsize
    if ~isempty(char(Text(n,1)))          
        fprintf(rsltF, '%s: %10s\n', char(Text(n,1)), char(Text(n,2)));
    else
        break;
    end
end
% log the test results
dateofTestExec = date;
fprintf(rsltF, 'Date of test execution: %10s\n', dateofTestExec);
fprintf(rsltF, '%s\n', '********************************************************************************');
del_cnt = 0;
for sheet_index = 1:length(TestCases)
    if strcmp(TestCases{sheet_index-del_cnt}, 'Signal Data Details')
        TestCases(sheet_index)='';
        del_cnt = del_cnt+1;
    end
end
% For each test group specified in each excel sheet
for sheet_index = 1:length(TestCases)
    if ~strcmp(TestCases{sheet_index}, 'Signal Data Details')
        % read xls for text and numerics
        [Num,Text]=xlsread(XlsFile,TestCases{sheet_index});

        % remove rows with 'Type' column set to other than 'D'
        % then remove columns with field name 'Step' and 'Type'
        for ridx = 1:size(Text,1)
            if strcmp(Text(ridx,2),'Time(ms)')
                rTime=ridx;
                break;
            end
        end
        tempText = Text;
        del_cnt = 0;
        for rowType=1:size(tempText,1)
            if strcmp(Text(rowType-del_cnt,3), 'C')
                Text(rowType-del_cnt,:) = [];
                Num(rowType-del_cnt-rTime,:) = [];
                del_cnt = del_cnt+1;
            end
        end
        % then remove columns with field name 'Step' and 'Type'
        Text(:,1) = [];
        Text(:,2) = [];
        Num(:,1) = [];
        Num(:,2) = [];

        % Use signals names of the first sheet as reference.
        for rowidx = 1:size(Text,1)
            if strcmp(Text(rowidx,1),'Time(ms)')
                SignalName=Text(rowidx,2:end);
                break;
            end
        end
        % Check consistent of signals names.
        if ~isequal(sign, SignalName)
           for idx=1:length(sign)
               signame = sprintf('%s', char(sign(idx)));
               SiGNam = sprintf('%s', char(SignalName(idx)));
               if ~strcmp(signame,SiGNam)
                   error('\nError: Signals Names mismatch: ''%s'' and ''%s'' signal names mismatch.\n', signame, SiGNam);
               end
           end
           errordlg('Signals Names mismatch - Check input and output Signal names in the test case sheet are in the order of the associated port numbers. Input signal names same as model input signals. Output signal names are required to be prepended with "Exp_"');
           return;
        end
        % Create time vector
        Time{sheet_index}=Num(:,1); % div by 1000 to convert time input in ms to seconds.
        % Create data
        for s=2:size(Text,2)
            Data{s-1,sheet_index}=Num(:,s);
        end

        % if an input signal is marked 'X' use the previous input value
        % if an input signal is marked 'X' use the previous input value, except
        % first step wherein expected output is set to '0', however such
        % outputs marked 'X' are ignored for test result comparision.
        % ***Inputs signals values for the first step are to be provided. They
        % cannot be marked 'X' at the first step.
        for i=2:size(Text,2)
            for item =1:size(Time{sheet_index},1)
                %isnan returns 1 when "Data{i-1,sheet_index}(item)" value
                %is Nan.otherwise 0.
                if isnan(Data{i-1,sheet_index}(item))
                    if item == 1
                        % this is only if the expected output is to be ignored
                        % ******but first row of the input signals needs to provided with 
                        % numeric values******
                        Data{i-1,sheet_index}(item)=0;
                    else
                        Data{i-1,sheet_index}(item)=Data{i-1,sheet_index}(item-1);
                    end
                end
            end
        end
    end 
end

% create a signal builder block with test data
blk = signalbuilder(blk, 'create', Time,Data,sign,TestCases);
set_param(blk,'Position',pos);

% reconnect lines
for n=1:length(lineDst)
    add_line(bdroot,sprintf('%s/%d',get_param(blk,'Name'),n),lineDst{n});
end
