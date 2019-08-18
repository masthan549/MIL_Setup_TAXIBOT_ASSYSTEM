function varargout = TaxiDemo_updategui(varargin)

%create a run time object that can return the value of the gain block's
%output and then put the value in a string.
rto1 = get_param('TXB_Context_PCM_Context/Data Type Conversion1','RuntimeObject');
str1 = num2str(rto1.OutputPort(1).Data);

%disp(['Output from Simulink is2: ',str1]);

rto2 = get_param('TXB_Context_PCM_Context/Data Type Conversion','RuntimeObject');
str2 = num2str(rto2.OutputPort(1).Data);
% 
rto3 = get_param('TXB_Context_PCM_Context/Data Type Conversion3','RuntimeObject');
str3 = num2str(rto3.OutputPort(1).Data);

rto4 = get_param('TXB_Context_PCM_Context/Data Type Conversion2','RuntimeObject');
str4 = num2str(rto4.OutputPort(1).Data);

rto5 = get_param('TXB_Context_PCM_Context/Data Type Conversion4','RuntimeObject');
str5 = num2str(rto5.OutputPort(1).Data);

rto6 = get_param('TXB_Context_PCM_Context/Data Type Conversion5','RuntimeObject');
str6 = num2str(rto6.OutputPort(1).Data);

rto7 = get_param('TXB_Context_PCM_Context/Data Type Conversion70','RuntimeObject');
str7 = num2str(rto7.OutputPort(1).Data);
%get a handle to the GUI's 'current state' window

%Speed
statestxt15 = findobj('Tag','text5'); %report health monitering warnings

statestxt1 = findobj('Tag','edit1'); %FL
statestxt2 = findobj('Tag','edit2'); %FR
statestxt3 = findobj('Tag','edit3'); %RL
statestxt4 = findobj('Tag','edit4'); %RR
statestxt5 = findobj('Tag','edit5'); %System mode

statestxt6 = findobj('Tag','radiobutton1'); %System mode
statestxt7 = findobj('Tag','radiobutton2'); %System mode
statestxt8 = findobj('Tag','radiobutton3'); %System mode

%Steering Angle
% statestxt9 = findobj('Tag','edit6'); %FL
% statestxt10 = findobj('Tag','edit7'); %FR
% statestxt11 = findobj('Tag','edit8'); %RL
% statestxt12 = findobj('Tag','edit9'); %RR
statestxt14 = findobj('Tag','pushbutton3'); %pushbutton

%update the gui

%Tug Speed
set(statestxt1,'string',str1);
set(statestxt2,'string',str2);
set(statestxt3,'string',str3);
set(statestxt4,'string',str4);

%Tug System Mode
set(statestxt5,'string',str5);

%Tug Angle
% set(statestxt9,'string',str6);
% set(statestxt10,'string',str6);
% set(statestxt11,'string',str6);
% set(statestxt12,'string',str6);

 if(ne(rto7.OutputPort(1).Data,0))
     set(statestxt15,'string','HM_PILOT_DRIVER_ALERT_E');
 else
     set(statestxt15,'string',' ');
 end    

if(isequal(rto5.OutputPort(1).Data,0) || isequal(rto5.OutputPort(1).Data,2))
   set(statestxt14,'string','LVC Control');
   set(statestxt14,'BackgroundColor',[0 1 0]);
   
   try
        msgEvel = evalin('base','msgBox');
        delete(msgEvel);
   catch
        
   end
        
else
    set(statestxt14,'string','HLC Control');
    set(statestxt14,'BackgroundColor',[0.702 0.78 1.0]);
    set(statestxt14,'BackgroundColor',[0 1 0]);
end   

if(isequal(rto5.OutputPort(1).Data,4) || (isequal(rto5.OutputPort(1).Data, 2)) || (isequal(rto5.OutputPort(1).Data, 9)) || (isequal(rto5.OutputPort(1).Data, 3)))
    set(statestxt6,'Value',0);
    set(statestxt8,'Value',0);
    set(statestxt7,'Value',0);
    
    set(statestxt7,'BackgroundColor',[0.702 0.78 1.0]);   
    set(statestxt6,'BackgroundColor',[0.702 0.78 1.0]);  
    set(statestxt8,'BackgroundColor',[0.702 0.78 1.0]);    
end    

if(rto5.OutputPort(1).Data == 2)
    set(statestxt7,'Value',0);
    set(statestxt8,'Value',0);
    set(statestxt6,'Value',1);  
    
    set(statestxt6,'BackgroundColor',[0 1 0]);    
    set(statestxt7,'BackgroundColor',[0.702 0.78 1.0]);  
    set(statestxt8,'BackgroundColor',[0.702 0.78 1.0]);   
end    

%Pre-Mission
if(rto5.OutputPort(1).Data == 3)
    set(statestxt6,'Value',0);
    set(statestxt8,'Value',0);
    set(statestxt7,'Value',1);
    
    set(statestxt7,'BackgroundColor',[0 1 0]);   
    set(statestxt6,'BackgroundColor',[0.702 0.78 1.0]);  
    set(statestxt8,'BackgroundColor',[0.702 0.78 1.0]);      
end

%DCM
if(rto5.OutputPort(1).Data == 4)
    set(statestxt6,'Value',0);
    set(statestxt8,'Value',0);
    set(statestxt7,'Value',1);
    
    set(statestxt7,'BackgroundColor',[0 1 0]);   
    set(statestxt6,'BackgroundColor',[0.702 0.78 1.0]);  
    set(statestxt8,'BackgroundColor',[0.702 0.78 1.0]);
end    

if(rto5.OutputPort(1).Data == 9)
    set(statestxt6,'Value',0);
    set(statestxt7,'Value',0);
    set(statestxt8,'Value',1);
    
    set(statestxt6,'BackgroundColor',[0.702 0.78 1.0]);    
    set(statestxt7,'BackgroundColor',[0.702 0.78 1.0]);  
    set(statestxt8,'BackgroundColor',[0 1 0]);   
end   
