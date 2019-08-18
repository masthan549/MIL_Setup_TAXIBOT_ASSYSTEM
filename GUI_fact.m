function varargout = GUI_fact(varargin)
% GUI_FACT MATLAB code for GUI_fact.fig
%      GUI_FACT, by itself, creates a new GUI_FACT or raises the existing
%      singleton*.
%
%      H = GUI_FACT returns the handle to a new GUI_FACT or the handle to
%      the existing singleton*.
%
%      GUI_FACT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_FACT.M with the given input arguments.
%
%      GUI_FACT('Property','Value',...) creates a new GUI_FACT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_fact_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_fact_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_fact

% Last Modified by GUIDE v2.5 23-Mar-2015 11:30:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_fact_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_fact_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_fact is made visible.
function GUI_fact_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_fact (see VARARGIN)

% Choose default command line output for GUI_fact
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_fact wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_fact_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function number_Callback(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of number as text
%        str2double(get(hObject,'String')) returns contents of number as a double


% --- Executes during object creation, after setting all properties.
function number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in factorial.
function factorial_Callback(hObject, eventdata, handles)
% hObject    handle to factorial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n = str2num(get(handles.number,'string'));
f = 1;
for i=1:n
    f = f * i;
end
ff = num2str(f);
set(handles.dcd_vel_tugWsRR_kts,'string',ff);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over dcd_vel_tugWsRR_kts.
function dcd_vel_tugWsRR_kts_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to dcd_vel_tugWsRR_kts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function dcd_vel_tugWsRR_kts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dcd_vel_tugWsRR_kts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
