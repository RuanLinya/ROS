function varargout = FrankaGUI(varargin)
% FRANKAGUI MATLAB code for FrankaGUI.fig
%      FRANKAGUI, by itself, creates a new FRANKAGUI or raises the existing
%      singleton*.
%
%      H = FRANKAGUI returns the handle to a new FRANKAGUI or the handle to
%      the existing singleton*.
%
%      FRANKAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRANKAGUI.M with the given input arguments.
%
%      FRANKAGUI('Property','Value',...) creates a new FRANKAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FrankaGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FrankaGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FrankaGUI

% Last Modified by GUIDE v2.5 13-Jul-2022 11:32:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FrankaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FrankaGUI_OutputFcn, ...
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


% --- Executes just before FrankaGUI is made visible.
function FrankaGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FrankaGUI (see VARARGIN)

% Choose default command line output for FrankaGUI
handles.output = hObject;
% global modrobot
global Ttool
%% 导入机器人工具箱模型
% type = 'modified';
% %建立机器人模型
% %       theta    d           a        alpha     offset
% ML1=Link([0      0.333       0         0         0     ],type); 
% ML2=Link([0      0           0        -pi/2      0     ],type);
% ML3=Link([0      0.316       0         pi/2      0     ],type);
% ML4=Link([0      0           0.0825    pi/2      0     ],type);
% ML5=Link([0      0.384      -0.0825   -pi/2      0     ],type);
% ML6=Link([0      0           0         pi/2      0     ],type);
% ML7=Link([0      0           0.088     pi/2      0     ],type);
% ML1.qlim = [-pi pi];
% ML2.qlim = [-2*pi/3 2*pi/3];
% ML3.qlim = [-pi pi];
% ML4.qlim = [-pi pi/3];
% ML5.qlim = [-pi pi];
% ML6.qlim = [0 250*pi/180];
% ML7.qlim = [-pi pi];
% modrobot=SerialLink([ML1 ML2 ML3 ML4 ML5 ML6 ML7],'name','7DOF ARM');
%%

%% 末端坐标系和工具坐标系的转换矩阵
Ttool = [1 0 0 0;
         0 1 0 0;
         0 0 1 0.207;
         0 0 0 1];
%%
% 添加其它工作路径
addpath('Fanka_STL');
addpath('Tool_functions');

% 末端箭头坐标数据
a = 0.005;  % 箭尾圆柱半径
b = 0.3;    % 箭尾圆柱长度
c = 0.04;    % 箭头圆面半径
d = 0.1;    % 箭头圆面至锥定顶的高度
N = 100;    % 箭头mesh数据密集点个数

% 方形物体尺寸
length = 0.1;
width = 0.1;
high = 0.1;

% w = 1.5*[-1 1 -1 1 -0.1 1];
% axis(w);
daspect([1 1 1]);
light('Position', [0 0 5]);
light('Position', [2 2 1]);
axis equal
grid on
xlabel('X')
ylabel('Y');
zlabel('Z');
rotate3d on
view(50, 22);

% 建立第一个机械臂的转换齐次矩阵
handles.plane = hgtransform('Tag', 'plane');
handles.ring1 = hgtransform('Tag', 'ring1');
handles.ring2 = hgtransform('Tag', 'ring2');
handles.ring3 = hgtransform('Tag', 'ring3');
handles.ring4 = hgtransform('Tag', 'ring4');
handles.ring5 = hgtransform('Tag', 'ring5');
handles.ring6 = hgtransform('Tag', 'ring6');
handles.ring7 = hgtransform('Tag', 'ring7');
handles.hand = hgtransform('Tag', 'hand');
handles.finger1 = hgtransform('Tag', 'finger1');
handles.finger2 = hgtransform('Tag', 'finger2');
handles.Z = hgtransform('Tag', 'Z');
handles.Y = hgtransform('Tag', 'Y');
handles.X = hgtransform('Tag', 'X');

% 建立第方块物体的转换齐次矩阵
handles.Square = hgtransform('Tag', 'Square');

% 建立第二个机械臂的转换齐次矩阵
handles.plane_2 = hgtransform('Tag', 'plane_2');
handles.ring1_2 = hgtransform('Tag', 'ring1_2');
handles.ring2_2 = hgtransform('Tag', 'ring2_2');
handles.ring3_2 = hgtransform('Tag', 'ring3_2');
handles.ring4_2 = hgtransform('Tag', 'ring4_2');
handles.ring5_2 = hgtransform('Tag', 'ring5_2');
handles.ring6_2 = hgtransform('Tag', 'ring6_2');
handles.ring7_2 = hgtransform('Tag', 'ring7_2');
handles.hand_2 = hgtransform('Tag', 'hand_2');
handles.finger1_2 = hgtransform('Tag', 'finger1_2');
handles.finger2_2 = hgtransform('Tag', 'finger2_2');
handles.Z_2 = hgtransform('Tag', 'Z_2');
handles.Y_2 = hgtransform('Tag', 'Y_2');
handles.X_2 = hgtransform('Tag', 'X_2');

%% 导入机械臂1的STL模型
% 基座部件
[V,F] = stlRead( 'link0.stl' );
patch('Faces',F,'Vertices',V,'FaceColor', 0.8*[1.0000    0.7812    0.4975], ...
    'EdgeAlpha', 0,'Parent', handles.plane)
% 连杆1
[V,F] = stlRead( 'link1.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring1);
% 连杆2
[V,F] = stlRead( 'link2.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring2);
% 连杆3
[V,F] = stlRead( 'link3.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring3);
% 连杆4
[V,F] = stlRead( 'link4.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring4);
% 连杆5
[V,F] = stlRead( 'link5.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring5);
% 连杆6
[V,F] = stlRead( 'link6.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring6);
% 连杆7
[V,F] = stlRead( 'link7.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring7);
% hand
[V,F] = stlRead( 'hand.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.hand);
% finger1
[V,F] = stlRead( 'finger.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.finger1);
% finger2
[V,F] = stlRead( 'finger.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.finger2);
% 末端箭头坐标轴Z
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.Z);
% 末端箭头坐标轴Y
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.Y);
% 末端箭头坐标轴X
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'r', 'EdgeAlpha', 0,'Parent', handles.X);
%%

%% 方块物体坐标系
[V,F] = squareplot(length,width,high);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', [0.5,0.5,0.5], 'EdgeAlpha', 0,'Parent', handles.Square);
%%

%% 导入机械臂2的STL模型
% 基座部件
[V,F] = stlRead( 'link0.stl' );
patch('Faces',F,'Vertices',V,'FaceColor', 0.8*[1.0000    0.7812    0.4975], ...
    'EdgeAlpha', 0,'Parent', handles.plane_2)
% 连杆1
[V,F] = stlRead( 'link1.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring1_2);
% 连杆2
[V,F] = stlRead( 'link2.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring2_2);
% 连杆3
[V,F] = stlRead( 'link3.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring3_2);
% 连杆4
[V,F] = stlRead( 'link4.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring4_2);
% 连杆5
[V,F] = stlRead( 'link5.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring5_2);
% 连杆6
[V,F] = stlRead( 'link6.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring6_2);
% 连杆7
[V,F] = stlRead( 'link7.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring7_2);
% hand
[V,F] = stlRead( 'hand.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.hand_2);
% finger1
[V,F] = stlRead( 'finger.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.finger1_2);
% finger2
[V,F] = stlRead( 'finger.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.finger2_2);
% 末端箭头坐标轴Z
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.Z_2);
% 末端箭头坐标轴Y
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.Y_2);
% 末端箭头坐标轴X
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'r', 'EdgeAlpha', 0,'Parent', handles.X_2);
%%


% set the initial value of text fields
set(handles.text2, 'String', num2str(sprintf('%.1f', get(handles.slider1, 'Value'))));
set(handles.text3, 'String', num2str(sprintf('%.1f', get(handles.slider3, 'Value'))));
set(handles.text4, 'String', num2str(sprintf('%.1f', get(handles.slider4, 'Value'))));
set(handles.text5, 'String', num2str(sprintf('%.1f', get(handles.slider5, 'Value'))));
set(handles.text6, 'String', num2str(sprintf('%.1f', get(handles.slider6, 'Value'))));
set(handles.text7, 'String', num2str(sprintf('%.1f', get(handles.slider7, 'Value'))));
set(handles.text8, 'String', num2str(sprintf('%.1f', get(handles.slider8, 'Value'))));
set(handles.text9, 'String', num2str(sprintf('%.1f', get(handles.slider9, 'Value'))));

% Update handles structure
guidata(hObject, handles);

% ask for continuous callbacks
addlistener(handles.slider1, 'ContinuousValueChange', ...
    @(obj,event) slider1_Callback(obj, event, handles) );
addlistener(handles.slider3, 'ContinuousValueChange', ...
    @(obj,event) slider3_Callback(obj, event, handles) );
addlistener(handles.slider4, 'ContinuousValueChange', ...
    @(obj,event) slider4_Callback(obj, event, handles) );
addlistener(handles.slider5, 'ContinuousValueChange', ...
    @(obj,event) slider5_Callback(obj, event, handles) );
addlistener(handles.slider6, 'ContinuousValueChange', ...
    @(obj,event) slider6_Callback(obj, event, handles) );
addlistener(handles.slider7, 'ContinuousValueChange', ...
    @(obj,event) slider7_Callback(obj, event, handles) );
addlistener(handles.slider8, 'ContinuousValueChange', ...
    @(obj,event) slider8_Callback(obj, event, handles) );
addlistener(handles.slider9, 'ContinuousValueChange', ...
    @(obj,event) slider9_Callback(obj, event, handles) );

update(handles)

% UIWAIT makes FrankaGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FrankaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2, 'String', num2str(sprintf('%.1f', get(hObject, 'Value'))));
update(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text3, 'String', num2str(sprintf('%.1f', get(hObject, 'Value'))));
update(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text4, 'String', num2str(sprintf('%.1f', get(hObject, 'Value'))));
update(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text5, 'String', num2str(sprintf('%.1f', get(hObject, 'Value'))));
update(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text6, 'String', num2str(sprintf('%.1f', get(hObject, 'Value'))));
update(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text7, 'String', num2str(sprintf('%.1f', get(hObject, 'Value'))));
update(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text8, 'String', num2str(sprintf('%.1f', get(hObject, 'Value'))));
update(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text9, 'String', num2str(sprintf('%.1f', get(hObject, 'Value'))));
update(handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function update(handles)
global Ttool
% 获取滑块各关节角度值
q1 = get(handles.slider1, 'Value')*pi/180;
q2 = get(handles.slider3, 'Value')*pi/180;
q3 = get(handles.slider4, 'Value')*pi/180;
q4 = get(handles.slider5, 'Value')*pi/180;
q5 = get(handles.slider6, 'Value')*pi/180;
q6 = get(handles.slider7, 'Value')*pi/180;
q7 = get(handles.slider8, 'Value')*pi/180;
d = get(handles.slider9, 'Value');
[PosAtt,T1,T2,T3,T4,T5,T6,T7] = Franka_FK(q1,q2,q3,q4,q5,q6,q7,Ttool);   % 计算正解，旋转矩阵

ang = -pi/4;
T8 = rpy2rotm(0,0,0.107,0,0,ang);

T91 = rpy2rotm(0,0,0.0584,0,0,0);
T92 = rpy2rotm(0,0,0.0584,0,0,0)*rpy2rotm(0,0,0,0,0,pi);

% 末端卡爪转换矩阵
Td1 = [  1    0    0    0
         0    1    0    d
         0    0    1    0
         0    0    0    1];
Td2 = [  1    0    0    0
         0    1    0    d
         0    0    1    0
         0    0    0    1];

% 两机械臂整体坐标变化
Ts = [1 0 0 0;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];
Ts2 = [-1 0 0 1.4;
      0 -1 0 0;
      0 0 1 0;
      0 0 0 1];
  
% 方块物体整体坐标变化
Tsq = [1 0 0 0.7-0.1/2;
       0 1 0 0.3-0.1/2;
       0 0 1 0.8-0.1/2;
       0 0 0 1];

%% 设定第一个机械臂的转换矩阵
set(handles.plane, 'Matrix', Ts);
set(handles.ring1, 'Matrix', Ts*T1);
set(handles.ring2, 'Matrix', Ts*T2);
set(handles.ring3, 'Matrix', Ts*T3);
set(handles.ring4, 'Matrix', Ts*T4);
set(handles.ring5, 'Matrix', Ts*T5);
set(handles.ring6, 'Matrix', Ts*T6);
set(handles.ring7, 'Matrix', Ts*T7);
set(handles.hand, 'Matrix', Ts*T7*T8);
set(handles.finger1, 'Matrix', Ts*T7*T8*T91*Td1);
set(handles.finger2, 'Matrix', Ts*T7*T8*T92*Td2);

R1 = r2t(rotx(-pi/2))*r2t(roty(pi/4));
R2 = r2t(roty(pi/2))*r2t(rotx(pi/4));
set(handles.Z, 'Matrix', Ts*T7*Ttool);
set(handles.Y, 'Matrix', Ts*T7*Ttool*R1);
set(handles.X, 'Matrix', Ts*T7*Ttool*R2);
%%

%% 设定第二个机械臂的转换矩阵
Tarm1 = Ts2;
Tarm2 = Ts2*T1;
Tarm3 = Ts2*T2;
Tarm4 = Ts2*T3;
Tarm5 = Ts2*T4;
Tarm6 = Ts2*T5;
Tarm7 = Ts2*T6;
Tarm8 = Ts2*T7;
Tarm9 = Ts2*T7*T8;
Tarm10 = Ts2*T7*T8*T91*Td1;
Tarm11 = Ts2*T7*T8*T92*Td2;
Tarm12 = Ts2*T7*Ttool;
Tarm13 = Ts2*T7*Ttool*R1;
Tarm14 = Ts2*T7*Ttool*R2;

set(handles.plane_2, 'Matrix', Tarm1);
set(handles.ring1_2, 'Matrix', Tarm2);
set(handles.ring2_2, 'Matrix', Tarm3);
set(handles.ring3_2, 'Matrix', Tarm4);
set(handles.ring4_2, 'Matrix', Tarm5);
set(handles.ring5_2, 'Matrix', Tarm6);
set(handles.ring6_2, 'Matrix', Tarm7);
set(handles.ring7_2, 'Matrix', Tarm8);
set(handles.hand_2, 'Matrix', Tarm9);
set(handles.finger1_2, 'Matrix', Tarm10);
set(handles.finger2_2, 'Matrix', Tarm11);

R1 = r2t(rotx(-pi/2))*r2t(roty(pi/4));
R2 = r2t(roty(pi/2))*r2t(rotx(pi/4));
set(handles.Z_2, 'Matrix', Tarm12);
set(handles.Y_2, 'Matrix', Tarm13);
set(handles.X_2, 'Matrix', Tarm14);
%%

%% 设定方块的转换矩阵
set(handles.Square, 'Matrix', Tsq);
%%

% 设定位姿显示模块
set(handles.text15, 'string', num2str(roundn(PosAtt(1),-3)));
set(handles.text16, 'string', num2str(roundn(PosAtt(2),-3)));
set(handles.text17, 'string', num2str(roundn(PosAtt(3),-3)));
set(handles.text11, 'string', num2str(roundn(PosAtt(4),-3)));
set(handles.text12, 'string', num2str(roundn(PosAtt(5),-3)));
set(handles.text13, 'string', num2str(roundn(PosAtt(6),-3)));


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% i=0:0.1:10;
% q1=1*i*pi/180;q2=50*sin(i/pi)*pi/180;q3=50*cos(i/pi)*pi/180;
% q4=1*i*pi/180;q5=1*i*pi/180;q6=10*i*pi/180;q7=10*i*pi/180;
d = get(handles.slider9, 'Value');
global Ta1
% global modrobot
global Ttool
R1 = Ta1(1:3,1:3);   % 选定姿态矩阵

%% 末端轨迹规划
% d_end = 0.05;
% A0 = [Ta1(1,4)-d_end,Ta1(2,4),Ta1(3,4)];
% A1 = [0.7-d_end 0 0.8];
% A2 = [0.7-d_end -0.2 0.6];
% A3 = [0.7-d_end 0 0.4];
% A4 = [0.7-d_end 0.2 0.6];
% e = 0.1;
% P0 = Interpolation(A0,A1,e);
% P1 = Interpolation(A1,A2,e);
% P2 = Interpolation(A2,A3,e);
% P3 = Interpolation(A3,A4,e);
% P4 = Interpolation(A4,A1,e);
% 
% N = size(P0,1);
% P1_t = [P1(:,1)-A1(1),P1(:,2)-A1(2),P1(:,3)-A1(3)];
% P2_t = [P2(:,1)-A1(1),P2(:,2)-A1(2),P2(:,3)-A1(3)];
% P3_t = [P3(:,1)-A1(1),P3(:,2)-A1(2),P3(:,3)-A1(3)];
% P4_t = [P4(:,1)-A1(1),P4(:,2)-A1(2),P4(:,3)-A1(3)];
% Pt = [zeros(N,3);P1_t;P2_t;P3_t;P4_t];
% P = [P0;P1;P2;P3;P4];
% Path2 = [P(:,1),-P(:,2),P(:,3)];

%% 两机械臂、方块末端轨迹规划
d_end = 0.05;
ed = 0.1;
et = 5*pi/180;
thetaC = 0:et:2*pi;
N = size(thetaC,2);
R = 0.2;     % 半径
C = [0.7,0,0.6];    % 圆心
yc = C(2)+R*(cos(pi/2+thetaC));
zc = C(3)+R*(sin(pi/2+thetaC));
xc = (C(1)-d_end).*ones(1,N);
Pc = [xc',yc',zc'];
A0 = [Ta1(1,4)-d_end,Ta1(2,4),Ta1(3,4)];
A01 = [Ta1(1,4)-d_end,0.3,0.8];
A12 = [0.7-d_end,0.3,0.8];
A2 = [0.7-d_end 0 0.8];
P0 = Interpolation(A0,A01,ed);
P1 = Interpolation(A01,A12,ed);
P2 = Interpolation(A12,A2,ed);
P0_2 = Interpolation(A0,A2,ed);   % 第二个机械臂运动到抓取点路径
Pt1 = Interpolation([0,0,0],[0,-0.3,0],ed);
Pt2 = [0,-0.3,0] + [zeros(1,N);R*(cos(pi/2+thetaC));R*(sin(pi/2+thetaC))-R]';
N1 = size([P0;P1;P2],1);
Ng = size([P0;P1],1);
N2 = size(P0_2,1);

P = [P0;P1;P2;P2(end,:)+zeros(N2,3);Pc];
PP = [A0+zeros(N1,3);P0_2;Pc];
Path2 = [PP(:,1),-PP(:,2),PP(:,3)];
Pt = [zeros(Ng,3);Pt1;Pt1(end,:)+zeros(N2,3);Pt2];

t1 = size([P0;P1;P2;P0_2],1)*0.1;
t2 = size(Pc,1)*0.05;
%%

% 方块物体整体坐标变化
Tsq = [1 0 0 0.7-0.1/2;
       0 1 0 0.3-0.1/2;
       0 0 1 0.8-0.1/2;
       0 0 0 1];
%%
% 两机械臂关节初值
q0 = [get(handles.slider1, 'Value'),get(handles.slider3, 'Value'),get(handles.slider4, 'Value'),...
    get(handles.slider5, 'Value'),get(handles.slider6, 'Value'),get(handles.slider7, 'Value'),...
    get(handles.slider8, 'Value')]*pi/180;
q20 = q0;

%% 根据规划末端轨迹和选定姿态，逆解获得俩机械臂关节变量
for i=1:size(P,1)
    M = [R1,P(i,:)';0 0 0 1];
    M2 = [R1,Path2(i,:)';0 0 0 1];
    Q(i,:) = NewtonRaphson_IK2(q0',M);
    Qp2(i,:) = NewtonRaphson_IK2(q20',M2);
%     Q(i,:)=modrobot.ikine(M,q0,[1 1 1 1 1 1 1]);
    q0 = Q(i,:);
    q20 = Qp2(i,:);
end
%%

q1 = Q(:,1);q2 = Q(:,2);q3 = Q(:,3);
q4 = Q(:,4);q5 = Q(:,5);q6 = Q(:,6);q7 = Q(:,7);

q1_2 = Qp2(:,1);q2_2 = Qp2(:,2);q3_2 = Qp2(:,3);
q4_2 = Qp2(:,4);q5_2 = Qp2(:,5);q6_2 = Qp2(:,6);q7_2 = Qp2(:,7);

%% 驱动机械臂运动
for i=1:length(q1)
    
    [PosAtt,T1,T2,T3,T4,T5,T6,T7] = Franka_FK(q1(i),q2(i),q3(i),q4(i),q5(i),q6(i),q7(i),Ttool);
    [PosAtt_2,T1_2,T2_2,T3_2,T4_2,T5_2,T6_2,T7_2] = Franka_FK(q1_2(i),q2_2(i),q3_2(i),q4_2(i),q5_2(i),q6_2(i),q7_2(i),Ttool);
    
    set(handles.slider1, 'Value',q1(i)*180/pi);
    set(handles.slider3, 'Value',q2(i)*180/pi);
    set(handles.slider4, 'Value',q3(i)*180/pi);
    set(handles.slider5, 'Value',q4(i)*180/pi);
    set(handles.slider6, 'Value',q5(i)*180/pi);
    set(handles.slider7, 'Value',q6(i)*180/pi);
    set(handles.slider8, 'Value',q7(i)*180/pi);
%     set(handles.slider9, 'Value',0);
    
    set(handles.text2, 'String', num2str(sprintf('%.1f', get(handles.slider1, 'Value'))));
    set(handles.text3, 'String', num2str(sprintf('%.1f', get(handles.slider3, 'Value'))));
    set(handles.text4, 'String', num2str(sprintf('%.1f', get(handles.slider4, 'Value'))));
    set(handles.text5, 'String', num2str(sprintf('%.1f', get(handles.slider5, 'Value'))));
    set(handles.text6, 'String', num2str(sprintf('%.1f', get(handles.slider6, 'Value'))));
    set(handles.text7, 'String', num2str(sprintf('%.1f', get(handles.slider7, 'Value'))));
    set(handles.text8, 'String', num2str(sprintf('%.1f', get(handles.slider8, 'Value'))));
%     set(handles.text9, 'String', num2str(sprintf('%.1f', get(handles.slider9, 'Value'))));
    
    update(handles)

    ang = -pi/4;
    T8 = rpy2rotm(0,0,0.107,0,0,ang);

    T91 = rpy2rotm(0,0,0.0584,0,0,0);
    T92 = rpy2rotm(0,0,0.0584,0,0,0)*rpy2rotm(0,0,0,0,0,pi);

    Td1 = [  1    0    0    0
             0    1    0    d
             0    0    1    0
             0    0    0    1];
    Td2 = [  1    0    0    0
             0    1    0    d
             0    0    1    0
             0    0    0    1];

    % 整体坐标变化
    Ts = [1 0 0 0;
          0 1 0 0;
          0 0 1 0;
          0 0 0 1];
    Ts2 = [-1 0 0 1.4;
           0 -1 0 0;
           0 0 1 0;
           0 0 0 1];
       
    %% 设定方块的转换矩阵
    I = [1 0 0;0 1 0;0 0 1];
    PP = [I,Pt(i,:)';0 0 0 1];
    set(handles.Square, 'Matrix', Tsq*PP);
    %%

    %% SET Arm1
    set(handles.plane, 'Matrix', Ts);
    set(handles.ring1, 'Matrix', Ts*T1);
    set(handles.ring2, 'Matrix', Ts*T2);
    set(handles.ring3, 'Matrix', Ts*T3);
    set(handles.ring4, 'Matrix', Ts*T4);
    set(handles.ring5, 'Matrix', Ts*T5);
    set(handles.ring6, 'Matrix', Ts*T6);
    set(handles.ring7, 'Matrix', Ts*T7);
    set(handles.hand, 'Matrix', Ts*T7*T8);
    set(handles.finger1, 'Matrix', Ts*T7*T8*T91*Td1);
    set(handles.finger2, 'Matrix', Ts*T7*T8*T92*Td2);

    R1 = r2t(rotx(-pi/2))*r2t(roty(pi/4));
    R2 = r2t(roty(pi/2))*r2t(rotx(pi/4));
    set(handles.Z, 'Matrix', Ts*T7*Ttool);
    set(handles.Y, 'Matrix', Ts*T7*Ttool*R1);
    set(handles.X, 'Matrix', Ts*T7*Ttool*R2);
    %%
    
   %% SET Arm2
    set(handles.plane_2, 'Matrix', Ts2);
    set(handles.ring1_2, 'Matrix', Ts2*T1_2);
    set(handles.ring2_2, 'Matrix', Ts2*T2_2);
    set(handles.ring3_2, 'Matrix', Ts2*T3_2);
    set(handles.ring4_2, 'Matrix', Ts2*T4_2);
    set(handles.ring5_2, 'Matrix', Ts2*T5_2);
    set(handles.ring6_2, 'Matrix', Ts2*T6_2);
    set(handles.ring7_2, 'Matrix', Ts2*T7_2);
    set(handles.hand_2, 'Matrix', Ts2*T7_2*T8);
    set(handles.finger1_2, 'Matrix', Ts2*T7_2*T8*T91*Td1);
    set(handles.finger2_2, 'Matrix', Ts2*T7_2*T8*T92*Td2);

    R1 = r2t(rotx(-pi/2))*r2t(roty(pi/4));
    R2 = r2t(roty(pi/2))*r2t(rotx(pi/4));
    set(handles.Z_2, 'Matrix', Ts2*T7_2*Ttool);
    set(handles.Y_2, 'Matrix', Ts2*T7_2*Ttool*R1);
    set(handles.X_2, 'Matrix', Ts2*T7_2*Ttool*R2);
    %%
    
    hold on;
    h(i)=plot3(PosAtt(1),PosAtt(2),PosAtt(3),'k.');  % 实时绘制机械臂1末端轨迹
    
    pause(0.1)  % 延时0.1s
end
fprintf('抓取时间：%.3f\n',t1);
fprintf('搬运时间：%.3f\n',t2);
%%
    


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ta1
global Ttool
% 获取滑块关节变量
q1 = get(handles.slider1, 'Value')*pi/180;
q2 = get(handles.slider3, 'Value')*pi/180;
q3 = get(handles.slider4, 'Value')*pi/180;
q4 = get(handles.slider5, 'Value')*pi/180;
q5 = get(handles.slider6, 'Value')*pi/180;
q6 = get(handles.slider7, 'Value')*pi/180;
q7 = get(handles.slider8, 'Value')*pi/180;
d = get(handles.slider9, 'Value');

% 选定机械臂姿态
[PosAtt,T1,T2,T3,T4,T5,T6,T7] = Franka_FK(q1,q2,q3,q4,q5,q6,q7,Ttool);
Ta1 = rpy2rotm(PosAtt(1),PosAtt(2),PosAtt(3),PosAtt(4),PosAtt(5),PosAtt(6));

% 更新滑块值
set(handles.slider1, 'Value',q1*180/pi);
set(handles.slider3, 'Value',q2*180/pi);
set(handles.slider4, 'Value',q3*180/pi);
set(handles.slider5, 'Value',q4*180/pi);
set(handles.slider6, 'Value',q5*180/pi);
set(handles.slider7, 'Value',q6*180/pi);
set(handles.slider8, 'Value',q7*180/pi);
set(handles.slider9, 'Value',d);
% 更新滑块显示值
set(handles.text2, 'String', num2str(sprintf('%.1f', get(handles.slider1, 'Value'))));
set(handles.text3, 'String', num2str(sprintf('%.1f', get(handles.slider3, 'Value'))));
set(handles.text4, 'String', num2str(sprintf('%.1f', get(handles.slider4, 'Value'))));
set(handles.text5, 'String', num2str(sprintf('%.1f', get(handles.slider5, 'Value'))));
set(handles.text6, 'String', num2str(sprintf('%.1f', get(handles.slider6, 'Value'))));
set(handles.text7, 'String', num2str(sprintf('%.1f', get(handles.slider7, 'Value'))));
set(handles.text8, 'String', num2str(sprintf('%.1f', get(handles.slider8, 'Value'))));
set(handles.text9, 'String', num2str(sprintf('%.1f', get(handles.slider9, 'Value'))));

update(handles)

