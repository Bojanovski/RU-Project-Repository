function varargout = Menu(varargin)
% MENU MATLAB code for Menu.fig
%      MENU, by itself, creates a new MENU or raises the existing
%      singleton*.
%
%      H = MENU returns the handle to a new MENU or the handle to
%      the existing singleton*.
%
%      MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MENU.M with the given input arguments.
%
%      MENU('Property','Value',...) creates a new MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Menu

% Last Modified by GUIDE v2.5 15-Jan-2016 15:57:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Menu_OpeningFcn, ...
                   'gui_OutputFcn',  @Menu_OutputFcn, ...
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


% --- Executes just before Menu is made visible.
function Menu_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Menu (see VARARGIN)

    % Choose default command line output for Menu
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    
    % Populate the listbox.
    % Get a list of all files and folders in this folder.
    files = dir('.');
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);
    listBoxData = {};
    for k = 1 : length(subFolders)
        listBoxData = [listBoxData, subFolders(k).name];
    end
    listBoxData(1:2) = [];
    % load the cell array into the listbox (assumed to be named listbox1
    set(handles.listbox1, 'String', listBoxData);
    

% --- Outputs from this function are returned to the command line.
function varargout = Menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1. Record
function pushbutton1_Callback(hObject, eventdata, handles)
    frameNum = get(handles.edit2, 'String');
    [num, status] = str2num(frameNum);
    videoName = get(handles.edit3, 'String');
    if status == 0 %not successful
        disp('Number of frames must be a number.');
    elseif isempty(videoName)
        disp('Video name must not be empty string.');
    else
        CaptureAndSave(num, videoName);
    end
    % Refresh the listbox.
    % Get a list of all files and folders in this folder.
    files = dir('.');
    % Get a logical vector that tells which is a directory.
    dirFlags = [files.isdir];
    % Extract only those that are directories.
    subFolders = files(dirFlags);
    listBoxData = {};
    for k = 1 : length(subFolders)
        listBoxData = [listBoxData, subFolders(k).name];
    end
    listBoxData(1:2) = [];
    % load the cell array into the listbox (assumed to be named listbox1
    set(handles.listbox1, 'String', listBoxData);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2. Play
function pushbutton2_Callback(hObject, eventdata, handles)
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    filename = file_list{index_selected}; % Item selected in list box
    fullPath = strcat(filename, '\\color_out.avi');
    if get(handles.radiobutton2,'Value') == 1
        fullPath = strcat(filename, '\\depth_out.avi');
    elseif get(handles.radiobutton3,'Value') == 1
        fullPath = strcat(filename, '\\P_color_out.avi');
        folderNotExists  = (exist(fullfile(fullPath), 'file') ~= 7);
        if folderNotExists
            msgbox('The recording you have selected has not been processed yet!', 'Error!');
            return;
        end
    end
    disp(strcat('Playing: ', fullPath));
    readerobj = VideoReader(fullPath, 'tag', 'myreader1');
    % % Read in all video frames.
    vidFrames = read(readerobj);
    
    % % Get the number of frames and frame rate.
    numFrames = get(readerobj, 'numberOfFrames');
    frameRate = get(readerobj, 'FrameRate');
    
    % Create a MATLAB movie struct from the video frames.
    for k = 1 : numFrames
        N=2;
        % Take every Nth pixel to downscale the frame.
        mov(k).cdata = vidFrames(1:N:size(vidFrames, 1), 1:N:size(vidFrames, 2), :,k);
        mov(k).colormap = [];
    end
    
    % % Create a figure
    hf = handles.axes1; 
    
    % Playback movie once at the video's frame rate
    movie(hf, mov, 1, frameRate, [0 0 0 0]);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
    
% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1. Color
function radiobutton1_Callback(hObject, eventdata, handles)
    set(handles.radiobutton1,'Value',1)
    set(handles.radiobutton2,'Value',0)
    set(handles.radiobutton3,'Value',0)

% --- Executes on button press in radiobutton2. Depth
function radiobutton2_Callback(hObject, eventdata, handles)
    set(handles.radiobutton1,'Value',0)
    set(handles.radiobutton2,'Value',1)
    set(handles.radiobutton3,'Value',0)
    
% --- Executes on button press in radiobutton2. Depth
function radiobutton3_Callback(hObject, eventdata, handles)
    set(handles.radiobutton1,'Value',0)
    set(handles.radiobutton2,'Value',0)
    set(handles.radiobutton3,'Value',1)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    workingDir = file_list{index_selected}; % Item selected in list box
    imageNamesColor = dir(fullfile(workingDir, 'images','RGB_*.png'));
    imageNamesDepth = dir(fullfile(workingDir, 'images','Depth_*.png'));
    imageNamesColor = {imageNamesColor.name}';
    imageNamesDepth = {imageNamesDepth.name}';
    
    % Depth has the same number of pictures.
    picNum = length(imageNamesColor);
    
    % Process and save images.
    disp('Processing images.');
    for i=1:picNum
        fullPathColor = strcat(strcat(workingDir, '\\images\\'), imageNamesColor{i});
        fullPathDepth = strcat(strcat(workingDir, '\\images\\'), imageNamesDepth{i});
        frameC = imread(fullPathColor);
        frameD = imread(fullPathDepth);
        % processed frame
        frameP = DrawFaceRectangle(frameC, frameD);
        imwrite(frameP, strcat(strcat(strcat(workingDir, '\\images\\P_'), imageNamesColor{i}),'.png'));
        %disp(strcat('Processed', int2str(i)))
    end
    disp('Making video file.');
    
    colorVid = VideoReader(strcat(workingDir, '\\color_out.avi'));
    info = get(colorVid);
    duration = info.Duration;
    ProcessedPNG2AVI(picNum/duration, workingDir);
    disp('Done processing.');
    


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
