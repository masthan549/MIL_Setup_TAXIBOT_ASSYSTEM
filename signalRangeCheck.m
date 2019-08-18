% read test data from excel sheet and add the same to signal builder block.
clear all
[XlsFile,] = uigetfile('*.xls','select data file');
if isequal(XlsFile,0)
    return
end

% Get Excel file sheet information
[~,TestCases] = xlsfinfo(XlsFile);
del_cnt = 0;
for sheet_index = 1:length(TestCases)
    if strcmp(TestCases{sheet_index-del_cnt}, 'Signal Data Details')
        TestCases(sheet_index)='';
        del_cnt = del_cnt+1;
    end
end

try
[DataVal,DataTxt]=xlsread(XlsFile,'Signal Data Details');
catch exception
   errordlg('Missing worksheet ''Signal Data Details'' in the input file ');
   error('Missing worksheet ''Signal Data Details'' in file ''%s''.', XlsFile);

end

rsltFN = sprintf('%s_SignalRangeCheck.log',XlsFile); 
rsltF = fopen(rsltFN, 'w');
fprintf(rsltF, '                      Signal Check log for ''%s''\n', XlsFile);
fprintf(rsltF, '%s\n', '********************************************************************************');
overall_result = 1;
% For each test group specified in each excel sheet
for sheet_index = 1:length(TestCases)
    fprintf(rsltF, '\nChecking signals in ''%s''\n', TestCases{sheet_index});
    fprintf(rsltF, '%s\n', '********************************************');
    if ~strcmp(TestCases{sheet_index}, 'Signal Data Details')
        % read xls for text and numerics
        [Num,Text]=xlsread(XlsFile,TestCases{sheet_index});
        % remove rows with 'Type' column set to other than 'D'
        % then remove columns with field name 'Step' and 'Type'
        for ridx = 1:size(Text,1)
            if strcmp(Text(ridx,2),'Time')
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
%         % then remove columns with field name 'Step' and 'Type'
        Text(:,3) = [];
%         Text(:,2) = [];
        Num(:,3) = [];
%         Num(:,2) = [];

        % Use signals names of the first sheet as reference.
        for rowidx = 1:size(Text,1)
            if strcmp(Text(rowidx,2),'Time')
                SignalName=Text(rowidx,3:end);
                break;
            end
        end
        
        % Time vector
        Time=Num(:,2);        
        % Data
        for s=3:size(Text,2)
            Data{s-2}=Num(:,s);
        end
        % step vector
        Step=Num(:,1);
        
        for i=1:length(SignalName)
            s2 = regexp(SignalName{i}, '\.', 'split');
            s3 = regexp(SignalName{i}, '^Exp_', 'split');
            if length(s2) > 1
                sigN = s2(2);
            elseif length(s3) > 1
                sigN = s3(2);
            else
                sigN = SignalName(i);
            end
            sigN=char(sigN);
            
            if strcmp(sigN,DataTxt(i+2,1))
                for t=1:size(Time,1)
                    if ~isnan(Data{i}(t))
                        if Data{i}(t) < DataVal(i,1)
                            fprintf(rsltF,'In test case ''%s'', for Signal ''%s'', at step %d, the input value ''%d'' is less than the functional minimum ''%d''of the signal.\n',TestCases{sheet_index},sigN,Step(t),Data{i}(t),DataVal(i,1));
                            overall_result = overall_result & 0;
                        elseif Data{i}(t) > DataVal(i,2)
                            fprintf(rsltF,'In test case ''%s'', for Signal ''%s'', at step %d, the input value ''%d'' is greater than the functional maximum ''%d''of the signal.\n',TestCases{sheet_index},sigN,Step(t),Data{i}(t),DataVal(i,2));
                            overall_result = overall_result & 0;
                        else
                            fprintf(rsltF,'In test case ''%s'', Signal ''%s'', at step %d - Data Range Check PASS.\n',TestCases{sheet_index},sigN,Step(t));
                        end
                        
                    end
                end
            else
                fprintf(rsltF,'Signal name ''%s'' does not match with the actual signal name ''%s''. Check if the signals or palced in the correct order.\n',char(DataTxt(i+2,1)), sigN);
            end
        end
        
    end 
end
fprintf(rsltF, '\n%s\n', '********************************************************************************');
if overall_result
    fprintf(rsltF,'Overall Signal Check Result: PASS');
else
    fprintf(rsltF,'Overall Signal Check Result: FAIL');
end
fprintf(rsltF, '\n%s', '********************************************************************************');