classdef runCMTDReport < handle
% runCMTDReport  A class to create automatic test report generation
%

%   Copyright 2010-2011 The MathWorks, Inc. 

    
    %% Propertis
    properties
        Model;
        Signal;
        FigFile;
        SimData;
        Setting;
        ResultFile;
        TestInpF;
    end
    methods
        function obj = runCMTDReport(blk, rsltFid,TestInpF)
            %%  Constructor
            if ~exist('blk','var')
                obj.Model.TestSubSys = gcb;
                obj.Model.TargetModel=bdroot(gcb);
            else
                obj.Model.TestSubSys = blk;
                obj.Model.TargetModel=bdroot(blk);
            end
            obj.Setting.ResultDir = fullfile(pwd,'figs');
            obj.Setting.FigPosition = [800 200];
            obj.Setting.PaperPosition = [0 0 15 5];
            % Reguler expression to find expected output signals
            obj.Setting.ExpectedSigStr='^Exp'; 
            % Reguler expression to find assertion signals
            obj.Setting.AssertionSigStr='^Assert'; 
            obj.Setting.ReportFileName = sprintf('%s_report',obj.Model.TargetModel);
            obj = obj.findSignalBuilderBlock;
            obj = obj.setSignalLoggingExpected;
            obj = obj.setSignalLoggingAssertion;
            obj = obj.setSignaLoggingTestSubSys;
            obj.ResultFile = rsltFid;
            obj.Setting.ResultStr.PASS='Pass';
            obj.Setting.ResultStr.FAIL='Fail';
            obj.Setting.ResultStr.NA='NA';
            obj.Setting.RPTfile = 'runCMTDreport_en.rpt';
            obj.TestInpF = TestInpF;
            if ~exist(obj.Setting.ResultDir,'dir')
                mkdir(obj.Setting.ResultDir)
            end
        end
        %% Configurations
        function obj = findSignalBuilderBlock(obj)
            % Find SignalBuider blocks
            blk=find_system(obj.Model.TargetModel,'MaskType','Sigbuilder block');
            if length(blk)>1 || isempty(blk)
                error('No or more than two Signal Builder blocks found in the model.')
            end
            obj.Model.SigBuilBlk=blk{1};
        end
        
        function grp = getSignalGroup(obj,nGrp)
            % Get group name in the SignalBuilder
            [t1,t2,t3,group]=signalbuilder(obj.Model.SigBuilBlk);
            if ~exist('nGrp','var')
                % No input argument means all group names
                grp=group;
            else
                % n-th group name if 2nd input argument is given
                grp = group{nGrp};
            end
        end
        function obj = setSignalLoggingExpected(obj)
            % Set logging signals on Expected Output signals
            obj.Signal.ExpectedSig = obj.setSignalLoggingRegex(obj.Setting.ExpectedSigStr);
        end
        function obj = setSignalLoggingAssertion(obj)
            % Set logging signals on Assertion signals
            obj.Signal.AssertionSig = obj.setSignalLoggingRegex(obj.Setting.AssertionSigStr);
        end
        
        function obj = setSignaLoggingTestSubSys(obj)
            % Set logging signals on Test targetted Subsystem
            lineH = get_param(obj.Model.TestSubSys,'LineHandles');
            portH = get_param(obj.Model.TestSubSys,'PortHandles');
            PortName ={'Inport','Outport'};
                for n=1:length(portH.Inport)
                    if ~isempty(get(portH.Inport(n),'Name'))
                        set(get(lineH.Inport(n),'SrcPortHandle'),'DataLogging',1);
                    else
                        warning('No signal name specified on %s#%d of %s\n','Inport',n,obj.Model.TestSubSys) %#ok
                    end
                    obj.Signal.Inport{n} = get(portH.Inport(n),'Name');
                end
                for n=1:length(portH.Outport)
                    if ~isempty(get(portH.Outport(n),'Name'))
                        set(portH.Outport(n),'DataLogging',1);
                    else
                        warning('No signal name specified on %s#%d of %s\n','Outport',n,obj.Model.TestSubSys) %#ok
                    end
                    obj.Signal.Outport{n} = get(portH.Outport(n),'Name');
                end
        end
        function enableModelSignalLogging(obj)
            % Enable SignalLogging on model configuration
            set_param(obj.Model.TargetModel,'SignalLogging','on')
        end
        function name = getModelSignalLoggingName(obj)
            name = get_param(obj.Model.TargetModel,'SignalLoggingName');
        end
        
        %% For simulations
        function obj = runSim(obj,nSig)
            [time,tmp2]=signalbuilder(obj.Model.SigBuilBlk);
            obj.enableModelSignalLogging;
            signalbuilder(obj.Model.SigBuilBlk,'ACTIVEGROUP',nSig);

            
            %% System is in INIT MODE
            %sim(obj.Model.TargetModel,[0 10]);
            %
            %% System entered into LVC MODE
            %h = msgbox('System Will enter into LVC mode','INIT Mode to LVC mode');
			%uiwait(h)
			%sim(obj.Model.TargetModel,[0 5020]);
            %
            %% System entered into PRE-MISSION MODE
            %h = msgbox('System Will enter into PRE-MISSION mode','LVC Mode to PRE-MISSION mode');
			%uiwait(h)		
            %sim(obj.Model.TargetModel,[0 10050]);			
            %
            %% System entered into DCM MODE
            %h = msgbox('System Will enter into DCM (Driver Control mode) mode','PRE-MISSION Mode to DCM mode');
			%uiwait(h)		
            %sim(obj.Model.TargetModel,[0 11640]);			
            %
            %% System entered into pcm MODE
            %h = msgbox('System Will enter into PCM (Pilot Control Mode) mode','DCM Mode to PCM mode');    
			%uiwait(h)			
			%sim(obj.Model.TargetModel,[0 218.1]);			
			sim(obj.Model.TargetModel,[min([time{:,nSig}]) max([time{:,nSig}])]);
            
            obj.SimData.CurrentSimNum = nSig;
            obj.SimData.CurrentLogsOut = eval(obj.getModelSignalLoggingName);
        end        
        
        function obj = runSimAll(obj)
            % Run all simulations and draw figures
            Nsig = length(obj.getSignalGroup);
            %open_system(obj.Model.SigBuilBlk)
            for n=1:Nsig
                fprintf('Running %d/%d..',n,Nsig)
                obj = obj.runSim(n);
                
                % These lines of code (results comarision and log results) is not required for Taxibotbot Demo ()
                
%                 obj = obj.plotCurrentResults;
                %obj = obj.resultComparison; // Commented this
%                 fopen(obj.ResultFile);
                %obj = obj.logResults(n); // Commented this
                fprintf('End\n');
            end
            fclose('all');
            save_system(obj.Model.TargetModel);
        end
        
        function obj = logResults(obj,logIdx)
            
            % Get Excel file sheet information
            [~,TestCases] = xlsfinfo(obj.TestInpF);
            % read xls for text and numerics
            [Num,Text]=xlsread(obj.TestInpF,TestCases{logIdx});

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
            Text(:,3) = [];
            Num(:,1) = [];
            Num(:,3) = [];

            % time vector
            Time{logIdx}=Num(:,1);        

            % find the new row id for acessing test data
            for rowidx = 1:size(Text,1)
                if strcmp(Text(rowidx,1),'Time(ms)')
                    rowstrt=rowidx;
                    break;
                end
            end
            
            fprintf(obj.ResultFile, '\n******************************************************\n');
            fprintf(obj.ResultFile, 'Results for Test case %d:', logIdx);
            fprintf(obj.ResultFile, '\n******************************************************\n');
            for Idx=1:length(obj.Signal.Outport)
                outdata = getSiginLogsOut(obj,obj.Signal.Outport{Idx});
                expdata = getSiginLogsOut(obj,sprintf('Exp_%s', obj.Signal.Outport{Idx}));
                assdata = getSiginLogsOut(obj,sprintf('Assert_%s', obj.Signal.Outport{Idx}));
                fprintf(obj.ResultFile, '\nOutput signal ''%s'':\n', obj.Signal.Outport{Idx}); 
                fprintf(obj.ResultFile, '*******************************************\n');
                for outN = 1:length(outdata.Data)
                    curr_row = 1;%MDF:previouly default value of row is 0. But MATLAB start positions from 1.
                    curr_col = 1;%
                     if any(Time{logIdx} == double(outdata.Time(outN)))
                        %fprintf('%d:%d\n',Idx,outN)                         
                         %when the Time(ms) is integer values
                        for i = 1:size(Time{logIdx},1)
                            if (abs(outdata.Time(outN)-Time{logIdx}(i))) == 0
                                curr_row = i;
                                break;
                            end
                        end
                        for j = 1:size(Text,2)
                            if strcmp(expdata.Name,char(Text(rowstrt,j)))
                                curr_col = j;
                                break;
                            end
                        end
                        if ~isnan(Num(curr_row,curr_col))
                            if ~isnumeric(outdata.Data(outN))
                                if assdata.Data(outN) == 0
                                   rsltstr = obj.Setting.ResultStr.FAIL;
                                else 
                                   rsltstr = obj.Setting.ResultStr.PASS;
                                end
                            else
                                if isnumeric(outdata.Data(outN))
                                   delta = 0.001;
                                   exp_data_max = expdata.Data(outN)+ delta;
                                   exp_data_min = expdata.Data(outN)- delta;
                                   if ((outdata.Data(outN) < exp_data_max) && (outdata.Data(outN) > exp_data_min))
                                      rsltstr = obj.Setting.ResultStr.PASS;
                                   else 
                                      rsltstr = obj.Setting.ResultStr.FAIL;
                                   end
                                end
                            end
                                fprintf(obj.ResultFile, 'At time %.2f: Expected value: %.8f,\tActual value: %.8f. Result: %s\n',outdata.Time(outN),double(expdata.Data(outN)),double(outdata.Data(outN)),rsltstr); 
                        end
                     else
                         %when the Time(ms) is float values
                         for i = 1:size(Time{logIdx},1)
                            if abs(outdata.Time(outN)-Time{logIdx}(i)) <= 0.001  %operating the floating values at tolerance 0.001
                                curr_row = i;
                                break;
                            end
                        end
                        for j = 1:size(Text,2)
                            if strcmp(expdata.Name,char(Text(rowstrt,j)))
                                curr_col = j;
                                break;
                            end
                        end
                        %fprintf('row:%f,col:%f\n',curr_row,curr_col)                        
                        if ~isnan(Num(curr_row,curr_col))
                            if ~isnumeric(outdata.Data(outN))
                                if assdata.Data(outN) == 0
                                   rsltstr = obj.Setting.ResultStr.FAIL;
                                else 
                                   rsltstr = obj.Setting.ResultStr.PASS;
                                end
                            else
                                if isnumeric(outdata.Data(outN))
                                   delta = 0.001;
                                   exp_data_max = expdata.Data(outN)+ delta;
                                   exp_data_min = expdata.Data(outN)- delta;
                                   if ((outdata.Data(outN) < exp_data_max) && (outdata.Data(outN) > exp_data_min))
                                      rsltstr = obj.Setting.ResultStr.PASS;
                                   else 
                                      rsltstr = obj.Setting.ResultStr.FAIL;
                                   end
                                end
                            end
                                fprintf(obj.ResultFile, 'At time %.2f: Expected value: %.8f,\tActual value: %.8f. Result: %s\n',outdata.Time(outN),double(expdata.Data(outN)),double(outdata.Data(outN)),rsltstr); 
                        end
                     end
                end
            end
        end
        
        % To run SImulink report generator
        function runReport(obj)
%             report(obj.Setting.RPTfile)
              report(obj.Model.TargetModel);
%               report(obj.Model.TestSubSys);
%               report(obj.Setting.ReportFileName)
        end
        function obj = resultComparison(obj)
            isValid = true;
            isOK = ones(length(obj.Signal.AssertionSig),1);
            for n=1:length(obj.Signal.AssertionSig)                
                sig = getSiginLogsOut(obj,obj.Signal.AssertionSig{n});
                if isempty(sig)
                    % Disable if Signal is empty
                    isValid = false;
                    obj.SimData.ComparisonResult(obj.SimData.CurrentSimNum).eachResultStr{n}=obj.Setting.ResultStr.NA;
                elseif any(sig.Data==false)
                    % Fail result if there is false
                    isOK(n) = false;
                    obj.SimData.ComparisonResult(obj.SimData.CurrentSimNum).eachResultStr{n}=obj.Setting.ResultStr.FAIL;
                else
                    % Pass result if there is no false
                    obj.SimData.ComparisonResult(obj.SimData.CurrentSimNum).eachResultStr{n}=obj.Setting.ResultStr.PASS;

                end
            end
            % Pass or Fail for all signals
            if ~isValid
                obj.SimData.ComparisonResult(obj.SimData.CurrentSimNum).All = obj.Setting.ResultStr.NA;
            elseif all(isOK)
                obj.SimData.ComparisonResult(obj.SimData.CurrentSimNum).All = obj.Setting.ResultStr.PASS;
            else
                obj.SimData.ComparisonResult(obj.SimData.CurrentSimNum).All = obj.Setting.ResultStr.FAIL;
            end
            
        end
        %% For Drawing
        function obj = plotCurrentResults(obj)
            % Draw inputs, outpus, expected outputs, and assertion signals
            obj.FigFile(obj.SimData.CurrentSimNum).InputSig=...
                plotCurrentSig(obj,obj.Signal.Inport,'InputSig');
            obj.FigFile(obj.SimData.CurrentSimNum).OutputSig=...
                plotCurrentSig(obj,obj.Signal.Outport,'OutputSig');
            obj.FigFile(obj.SimData.CurrentSimNum).ExpectedSig=...
                plotCurrentSig(obj,obj.Signal.ExpectedSig,'ExpectedSig');
            obj.FigFile(obj.SimData.CurrentSimNum).AssertionSig=...
                plotCurrentSig(obj,obj.Signal.AssertionSig,'AssertionSig');
        end
        
        function figFile = plotCurrentSig(obj,SigNames,FileName)
            % Draw all signals included in SigNames and save as file
            Nsig = length(SigNames);
            ScreenPos = get(0,'ScreenSize');
            fh = figure('Position',[ 1 ScreenPos(4)/2 obj.Setting.FigPosition],...
                'Color',[1 1 1]);
            %,'PaperPosition',obj.Setting.PaperPosition
            for n=1:Nsig
                %subplot(Nsig,1,n)
                %sig = obj.SimData.CurrentLogsOut.(SigNames{n});
                sig = getSiginLogsOut(obj,SigNames{n});
                plot(sig.Time,double(sig.Data),'r-x')
                ylabel(SigNames{n},'Interpreter','none')
                title(SigNames{n},'Interpreter','none')
                xlabel('Time')
                figFile{n} = fullfile(obj.Setting.ResultDir,...
                    sprintf('%s_Sig%03d_Sim%03d.bmp',FileName,n,obj.SimData.CurrentSimNum)); %#ok
                drawnow;
                print(fh,'-dbitmap','-r300',figFile{n});
            end
            close(fh)
        end
        
        
        %% Helper function
        function signal = getSiginLogsOut(obj,signame)
            obj.SimData.CurrentLogsOut.unpack('all');
            try
                signal = eval(signame);
            catch
                % Make it empty when no signal logging
                signal = [];
            end
        end
        function clearAllSignalLogging(obj)
            lineH = find_system(obj.Model.TargetModel,'FindAll','on', 'SearchDepth',1,'Regexp', 'on','type','line');
            for n=1:length(lineH)
                set(lineH(n),'DataLogging',false);
            end            
        end
        function logSigName = setSignalLoggingRegex(obj,pat)
            % Set signal logging on signals which match regular expression pat
            lineH = find_system(obj.Model.TargetModel,'FindAll','on', 'Regexp', 'on','type','line','Name',pat);
            ph=get(lineH,'SrcPortHandle');
            if length(ph) == 1
                set(ph,'DataLogging',1)
                logSigName=get(ph,'UserSpecifiedLogName');
            else    
                for n=1:length(ph)
                   set(ph{n},'DataLogging',1);
                   logSigName{n}=get(ph{n},'UserSpecifiedLogName');
                end
            end    
        end
    end
end