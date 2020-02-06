function varargout = pipeout_wirein(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pipeout_wirein_OpeningFcn, ...
                   'gui_OutputFcn',  @pipeout_wirein_OutputFcn, ...
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

% --- Executes just before pipein_wireout is made visible.
function pipeout_wirein_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_wirein1 (see VARARGIN)

% Choose default command line output for test_wirein1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = pipeout_wirein_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% cla(handles.axes1);
disp('hello world')'


% --- Executes on button press in enable.
function enable_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to enable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('hello world2');


% --- Executes on button press in test_signal.
function test_signal_Callback(hObject, eventdata, handles)
% hObject    handle to test_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
freq = str2double(get(handles.frequency,'String'));
t = eval(get(handles.time,'String'));

% Calculate data
x = sin(2*pi*freq*t);
% y = fft(x,512);
% m = y.*conj(y)/512;
% f = 1000*(0:256)/512;

%{
% Create frequency plot in proper axes
plot(handles.frequency_axes,f,m(1:257));
set(handles.frequency_axes,'XMinorTick','on');
grid on
%}

% Create time plot in proper axes
plot(handles.axes1,t,x);
set(handles.axes1,'XMinorTick','on');
% disp('hello world');
grid on



% --- Edit the frequency value of the test_signal.
function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
freq = str2double(get(hObject,'String'));
if isnan(freq) || ~isreal(freq)  
    set(handles.test_signal,'String','Unable to Plot');
    set(handles.test_signal,'Enable','off');
    uicontrol(hObject);
else 
    set(handles.test_signal,'String','Plot');
    set(handles.test_signal,'Enable','on');
end

% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
disp(hObject);
end



% --- Edit the time range value of the test_signal.
function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double
set(handles.test_signal,'Enable','off');
try
    t = eval(get(handles.time,'String'));
    if ~isnumeric(t)
        % t is not a number
        set(handles.test_signal,'String','t is not numeric')
    elseif length(t) < 2
        % t is not a vector
        set(handles.test_signal,'String','t must be vector')
    elseif length(t) > 1000
        % t is too long a vector to plot clearly
        set(handles.test_signal,'String','t is too long')
    elseif min(diff(t)) < 0
        % t is not monotonically increasing
        set(handles.test_signal,'String','t must increase')
    else
        % Enable the Plot button with its original name
        set(handles.test_signal,'String','Plot')
        set(handles.test_signal,'Enable','on')
        return
    end

 catch ME %#ok<*NASGU>
    % Cannot evaluate expression user typed
    set(handles.test_signal,'String','Cannot plot t');
    uicontrol(hObject);
end

% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
