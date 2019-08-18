function createComparingResults(sys,phSim,phExp)
substblkH={};
AssblkH={};
RelOpBlkH={};
TestUnitH = get_param(get(phSim(1),'Parent'),'handle');
for n=1:length(phSim)
    
    PortPos = get(phSim(n),'Position');
 
    % add Data Type Conversion to convert from any data type into double
    DTCblkH{n} = add_block('simulink/Signal Attributes/Data Type Conversion',[sys '/DTC' num2str(n)],'ShowName','off');
    set_param(DTCblkH{n},'Position',[PortPos(1)+100 PortPos(2)-5 PortPos(1)+140 PortPos(2)+5]);
    % Connect output signals of the Test harness to the DTC block
    add_line(sys,sprintf('%s/%d',get(TestUnitH,'Name'),n),[get(DTCblkH{n},'Name') '/1'],'autorouting','on')
    
    % place Add
    substblkH{n} = add_block('built-in/Sum',[sys '/Add' num2str(n)],...
        'Inputs','-+','OutDataTypeStr','double','AccumDataTypeStr','double','ShowName','off');
    % Adjust the position of the Test Harness Unit
    set_param(substblkH{n},'Position',[PortPos(1)+(180+10*n) PortPos(2)-10 PortPos(1)+(200+10*n) PortPos(2)+20]);
    substblkN{n}=getfullname(substblkH{n});
    
    % Connect output signals from DTC with 1st inport of Add
    add_line(sys,sprintf('%s/%d',get(DTCblkH{n},'Name'),1),[get(substblkH{n},'Name') '/1'],'autorouting','on')
    
    %Add Abs blcok
    AbsBlkH{n}=add_block('built-in/Abs',[sys '/Abs' num2str(n)],'ShowName','off');
    set_param(AbsBlkH{n},'Position',[PortPos(1)+(220+10*n) PortPos(2)-2 PortPos(1)+(250+10*n) PortPos(2)+22]);
    
    % Add  Compare To Constant
    RelOpBlkH{n} = add_block(['simulink/Logic and Bit Operations/' sprintf('Compare\nTo Constant')],...
        [bdroot '/Relop' num2str(n)]);
    set(RelOpBlkH{n},'relop','==','const','0','ShowName','off')
    set_param(RelOpBlkH{n},'Position',[PortPos(1)+(270+10*n) PortPos(2)-2 PortPos(1)+(290+10*n) PortPos(2)+22]);
    
    % Connect Assertion
    AssblkH{n} = add_block('built-in/Assertion',[sys '/Assertion' num2str(n)],'ShowName','off');
    set_param(AssblkH{n},'Position',[PortPos(1)+(350+10*n) PortPos(2)-2 PortPos(1)+(370+10*n) PortPos(2)+22]);

    add_line(sys,[get(substblkH{n},'Name') '/1'],sprintf('%s/%d',get(AbsBlkH{n},'Name'),1),'autorouting','on')
    add_line(sys,[get(AbsBlkH{n},'Name') '/1'],sprintf('%s/%d',get(RelOpBlkH{n},'Name'),1),'autorouting','on')
    lh_ass = add_line(sys,[get(RelOpBlkH{n},'Name') '/1'],sprintf('%s/%d',get(AssblkH{n},'Name'),1),'autorouting','on');
    set(lh_ass,'Name',sprintf('Assert_%s',get(phSim(n),'Name')));
end

% This is a way around to cater for the sample time for the added expected signals to the signal builder block. It is not possible to
% programatically change the simulation sample time of the signal builder block which is set to zero by default (can be changed on gui). Hence a
% Rate Transition Block is added to set the sample times fo the expected signals to 0.01. TBD to get reference of the system sample time and use to
% the same here for RTB blocks.
for n=1:length(phExp)
    PortPos = get(phExp(n),'Position');
 
    % add Data Type Conversion to convert from any data type into double
    ExpRTBblkH{n} = add_block('built-in/RateTransition',[sys '/RTB' num2str(n)],'ShowName','off');
    set_param(ExpRTBblkH{n},'Position',[PortPos(1)+(20*n) PortPos(2)-5 PortPos(1)+(20*n+50) PortPos(2)+5]);
    set_param(ExpRTBblkH{n},'OutPortSampleTime', '0.01');
    % Connect output signals of the SB to the RTB block
    rtbLineH  = add_line(sys,sprintf('%s/%d',get_param(get(phExp(n),'Parent'),'Name'),get(phExp(n),'PortNumber')),[get(ExpRTBblkH{n},'Name') '/1'],'autorouting','on');
    
    % Connect output signals from SignalBuilder with 2nd inport of Add
    rtb_line = add_line(sys,sprintf('%s/%d',get(ExpRTBblkH{n},'Name'),1),[get(substblkH{n},'Name') '/2'],'autorouting','on');
    set(rtb_line,'Name',sprintf('%s', get(phExp(n),'Name')));
    
    % remove signal labels to avoid duplicate signal logging
    set(rtbLineH,'Name','');

end