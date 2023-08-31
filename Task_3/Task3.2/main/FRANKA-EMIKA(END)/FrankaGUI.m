function varargout = FrankaGUI(varargin) 

gui_Singleton = 1;%first run without close and the second run will not run a new gut, instead take the first gui in front
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

% Choose default command line output for FrankaGUI
handles.output = hObject;
% global modrobot
global Ttool

%% 末端坐标系和工具坐标系的转换矩阵
Ttool = [1 0 0 0;
         0 1 0 0;
         0 0 1 0.207;
         0 0 0 1];
%%
% add other workpath
addpath('Fanka_STL');
addpath('Tool_functions');

% End arrow coordinate data 末端箭头坐标数据
a = 0.005/3;  % Radius of the arrow tail cylinder 箭尾圆柱半径
b = 0.3/3;    % Length of arrow tail cylinder 箭尾圆柱长度
c = 0.04/3;    % Radius of arrow circle 箭头圆面半径 
d = 0.1/3;    % Height from the round face of the arrow to the top of the cone 箭头圆面至锥定顶的高度
N = 100;    % Number of dense arrow mesh data points 箭头mesh数据密集点个数

% % % % object size
% % % length = 0.1;
% % % width = 0.1;
% % % high = 0.1;

% object size
length = 0.04;
width = 0.04;
high = 0.04;

% w = 1.5*[-1 1 -1 1 -0.1 1];
% axis(w);
daspect([1 1 1]);% Sets the data aspect ratio for the current coordinate area 设置当前坐标区的数据长宽比
light('Position', [0 0 5]);
light('Position', [2 2 1]);
axis equal
grid on
xlabel('X')
ylabel('Y');
zlabel('Z');
rotate3d on  % Rotation of elements using the 3D engine 使用3D引擎对元素进行旋转 
view(50, 20);% View Perspectives 查看视角

% Build the transformation matrix for the first robot arm 建立第一个机械臂的转换齐次矩阵
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

% Create a transformation matrix of square objects 建立方块物体的转换齐次矩阵
handles.Square = hgtransform('Tag', 'Square');

% Build the conversion matrix for the second robot arm建立第二个机械臂的转换齐次矩阵
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

%% Importing the STL model of robot arm 1 导入机械臂1的STL模型
% Base components 基座部件
[V,F] = stlRead( 'link0.stl' );
patch('Faces',F,'Vertices',V, ...
    'EdgeAlpha', 0,'Parent', handles.plane) % EdgeAlpha 边透明度
% link1 连杆1
[V,F] = stlRead( 'link1.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring1);
% link2 连杆2
[V,F] = stlRead( 'link2.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring2);
% link3 连杆3
[V,F] = stlRead( 'link3.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring3);
% link4 连杆4
[V,F] = stlRead( 'link4.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring4);
% link5 连杆5
[V,F] = stlRead( 'link5.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring5);
% link6 连杆6
[V,F] = stlRead( 'link6.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring6);
% link7 连杆7
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
% End arrow coordinate axis Z 末端箭头坐标轴Z
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.Z);
% End arrow coordinate axis Y 末端箭头坐标轴Y
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.Y);
% End arrow coordinate axis X 末端箭头坐标轴X
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'r', 'EdgeAlpha', 0,'Parent', handles.X);
%%

%% Cube object coordinate system 方块物体坐标系
[V,F] = squareplot(length,width,high);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', [0.5,0.5,0.5], 'EdgeAlpha', 0,'Parent', handles.Square);
%%

%% Importing the STL model of robot arm 2 导入机械臂2的STL模型
% Base components 基座部件
[V,F] = stlRead( 'link0.stl' );
patch('Faces',F,'Vertices',V, ...
    'EdgeAlpha', 0,'Parent', handles.plane_2)
% link1 连杆1
[V,F] = stlRead( 'link1.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring1_2);
% link2 连杆2
[V,F] = stlRead( 'link2.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring2_2);
% link3 连杆3
[V,F] = stlRead( 'link3.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring3_2);
% link4 连杆4
[V,F] = stlRead( 'link4.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring4_2);
% link5 连杆5
[V,F] = stlRead( 'link5.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring5_2);
% link6 连杆6
[V,F] = stlRead( 'link6.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring6_2);
% link7 连杆7
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
% End arrow coordinate axis Z 末端箭头坐标轴Z
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.Z_2);
% End arrow coordinate axis Y 末端箭头坐标轴Y
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.Y_2);
% End arrow coordinate axis X 末端箭头坐标轴X
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'r', 'EdgeAlpha', 0,'Parent', handles.X_2);
%%


% set the initial value of text fields 对GUT的滑块进行编程
set(handles.text2, 'String', num2str(sprintf('%.1f', get(handles.slider1, 'Value'))));% num2str 将数字转换为字符数组
set(handles.text3, 'String', num2str(sprintf('%.1f', get(handles.slider3, 'Value'))));% 句柄handle说白了就是编号
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
%if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %set(hObject,'BackgroundColor',[.9 .9 .9]);
%end


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
%if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   % set(hObject,'BackgroundColor',[.9 .9 .9]);
%end


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
%if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   % set(hObject,'BackgroundColor',[.9 .9 .9]);
%end


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
%if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %set(hObject,'BackgroundColor',[.9 .9 .9]);
%end


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
%if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %set(hObject,'BackgroundColor',[.9 .9 .9]);
%end


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
%if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %set(hObject,'BackgroundColor',[.9 .9 .9]);
%end


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
%if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    %set(hObject,'BackgroundColor',[.9 .9 .9]);
%end


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


function update(handles)
global Ttool
% Get the angle value of each joint of the slider 获取滑块各关节角度值
q1 = get(handles.slider1, 'Value')*pi/180;
q2 = get(handles.slider3, 'Value')*pi/180;
q3 = get(handles.slider4, 'Value')*pi/180;
q4 = get(handles.slider5, 'Value')*pi/180;
q5 = get(handles.slider6, 'Value')*pi/180;
q6 = get(handles.slider7, 'Value')*pi/180;
q7 = get(handles.slider8, 'Value')*pi/180;
d = get(handles.slider9, 'Value');
[PosAtt,T1,T2,T3,T4,T5,T6,T7] = Franka_FK(q1,q2,q3,q4,q5,q6,q7,Ttool);   % Calculating positive solutions, rotation matrix 计算正解，旋转矩阵

ang = -pi/4;
T8 = rpy2rotm(0,0,0.107,0,0,ang);

T91 = rpy2rotm(0,0,0.0584,0,0,0);
T92 = rpy2rotm(0,0,0.0584,0,0,0)*rpy2rotm(0,0,0,0,0,pi);

% End jaw conversion matrix 末端卡爪转换矩阵
% Td1 = [  cos(-ang)    0    sin(-ang)    0
%          0    1    0    d
%          -sin(-ang)    0    cos(-ang)    0
%          0    0    0    1];
Td1 = [  1    0    0    0
         0    1    0    d
         0    0    1    0
         0    0    0    1];
Td2 = [  1    0    0    0
         0    1    0    d
         0    0    1    0
         0    0    0    1];

% Starting coordinates of the two robotic arms 两机械臂起始坐标
Ts = [1 0 0 0;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];
Ts2 = [-1 0 0 0.4;
      0 -1 0 0;
      0 0 1 0;
      0 0 0 1];
  
%  Overall coordinate change of the square object 方块物体整体坐标变化
Tsq = [1 0 0 0.2-0.04/2;
       0 1 0 0.6-0.04/2;
       0 0 1 0.55-0.04/2;
       0 0 0 1];

%% Set the transition matrix for the first robot arm 设定第一个机械臂的转换矩阵
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

%% Set the conversion matrix for the second robot arm 设定第二个机械臂的转换矩阵
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

% Tarm1(2,4) = -Tarm1(2,4);Tarm2(2,4) = -Tarm2(2,4);Tarm3(2,4) = -Tarm3(2,4);
% Tarm4(2,4) = -Tarm4(2,4);Tarm5(2,4) = -Tarm5(2,4);Tarm6(2,4) = -Tarm6(2,4);
% Tarm7(2,4) = -Tarm7(2,4);Tarm8(2,4) = -Tarm8(2,4);Tarm9(2,4) = -Tarm9(2,4);
% Tarm10(2,4) = -Tarm10(2,4);Tarm11(2,4) = -Tarm11(2,4);Tarm12(2,4) = -Tarm12(2,4);
% Tarm13(2,4) = -Tarm13(2,4);Tarm14(2,4) = -Tarm14(2,4);

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

%% Set the transformation matrix of the squares 设定方块的转换矩阵
set(handles.Square, 'Matrix', Tsq);
%%

% Positioning pose display module 设定位姿显示模块
set(handles.text15, 'string', num2str(roundn(PosAtt(1),-3))); %PosAtt(1)-(6)就是指的是RPY XYZ GUI右上边
set(handles.text16, 'string', num2str(roundn(PosAtt(2),-3)));
set(handles.text17, 'string', num2str(roundn(PosAtt(3),-3)));
set(handles.text11, 'string', num2str(roundn(PosAtt(4),-3)));
set(handles.text12, 'string', num2str(roundn(PosAtt(5),-3)));
set(handles.text13, 'string', num2str(roundn(PosAtt(6),-3)));


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

d = get(handles.slider9, 'Value');
global Ta1
global Ttool

ed = 0.1;
et = 5*pi/180;
R1 = Ta1(1:3,1:3);   % Initial attitude matrix for robotic arms 1 and 2 机械臂1和2的初始姿态矩阵(3*3)
thetaC = 0:et:2*pi;% Selecting track points 选取轨迹点位
N = size(thetaC,2);
R = 0.2;     % Radius 半径
h = 0.2;    % Lifting height 抬升高度

%% Two robotic arms, end-of-square trajectory planning 两机械臂、方块末端轨迹规划
A0 = [Ta1(1,4),Ta1(2,4),Ta1(3,4)];   % starting position of robotic arm 1 机械臂1起始位置
A01 = [0.2,0.6,0.55];    % Arm 1 moves to the point where the object was originally located 机械臂1运动到物块原本所在的点
A2 = [Ta1(1,4), -Ta1(2,4)+0.2, Ta1(3,4)]; % Robot arm 2 moves to the start of the circular trajectory 机械臂2移动到圆形轨迹的起点
P0 = Interpolation(A0,A01,ed);    % Robotic arm 1 via point of assembly 1 机械臂1路经点集合1
P2 = Interpolation(A01,A0+[0,-0.2,0],ed);  % Robotic arm 1 via point of assembly 2 机械臂1路经点集合2

Pf1 = A01;    % Square relative to the start of the world coordinate system 方块相对于世界坐标系起点
Pf2 = A0 + [0,-0.2,0];    % Square path point 2 方块路径点2
Parm2 = [A2(1)-(A2(1)-0.2)*2,A2(2),A2(3)];   % Robotic arm 2 path point 2 机械臂2路径点2
P3 = Interpolation(A0,Parm2,ed); % Robotic arm 2 via point of assembly 1 机械臂2路经点集合1

Pfk1 = Pf2-Pf1;  % Translational path of the square 方块的平移路径
Pt1 = Interpolation([0,0,0],Pfk1,ed);   % Set of square waypoints1 (trajectory with respect to the starting point) 方块路经点集合1(相对于起始点运动轨迹)
N1 = size([P0;P2],1);% All points of robot arm 1 before it moves to a circular trajectory 机械臂1在运动到圆形轨迹前的所有点位
Ng = size(P0,1);% Robot arm 1 moves to all points of the starting point of the square 机械臂1移动到方块的起始点的所有点位
N2 = Ng;
N3 = size(P3,1);%Translational path points for robot arm 2 机械臂2的平移路径点位

%% Lifted section 抬升部分
Pfk2 = Pfk1 + [-(R+0.01),0,h];  % Square relative path point 3 方块相对路径点3.........R+0.01
Parm3 = Parm2 + [R+0.01,0,h];   % Robotic arm 2 path point 3 机械臂2路径点3........R+0.01
A3 = Pf2 + [-(R+0.01),0,h];   % Robotic arm 1 path point 3, circle start 机械臂1路径点3，圆起点............R+0.01
Pt2 = Interpolation(Pfk1,Pfk2,ed);  %  Square Waypoint Collection 2 方块路经点集合2
P4 = Interpolation(Pf2,A3,ed);   %  Robotic arm 1 Waypoint collection 4 机械臂1路经点集合4
Parm2_path2 = Interpolation(Parm2,Parm3,ed);  % Robotic arm 2 via point collection 2 机械臂2路经点集合2
N4 = size(P4,1);% Upward path points 上升路径点位

%% 开始画圆
Pc0 = A3;  % Start of circular trajectory 圆轨迹起点  [0.2351,-0.0027,0.4903+0.3]
C = [Pc0(1)-R,Pc0(2)+R,Pc0(3)];   % Center of circle 圆心..........R+0.01
yc = C(2)+R*(sin(thetaC)-1);  % y-trajectory of robot arm 1 机械臂1的y轨迹
xc = C(1)-R*(cos(thetaC)-1)+R;  % x-trajectory of robot arm 1 机械臂1的x轨迹
zc = C(3).*ones(1,N);  % z-trajectory of robot arm 1 机械臂1的z轨迹
Pc = [xc',yc',zc'];% Overall circular trajectory of robot arm 1 机械臂1的总体圆轨迹

% Calculate the meta-sequence of rotation matrix changes for robot arm 1 计算机械臂1的旋转矩阵变化的元胞序列
Arm1_R_end_Array = cell(1,N1+N2+N3+N4);   % Allocate tuple space 分配元胞数组空间
Arm1_R_end_tmp = rpy2rotm(0,0,0,0,-pi/2,0);  % Calculating the chi-square matrix 计算齐次矩阵(4*4)
Arm1_R_end_tmp2 = rpy2rotm(0,0,0,-pi/2,0,0);
Arm1_R_end = R1*Arm1_R_end_tmp(1:3,1:3);  % First change of attitude of robot arm 1 (turn -pi/2 around its end coordinate system Y axis) 机械臂1的第一次改变姿态(绕其末端坐标系Y轴转-pi/2)
Arm1_R_end2 = Arm1_R_end*Arm1_R_end_tmp2(1:3,1:3);  % Second change of attitude of robot arm 1 (-pi/2 around its end coordinate system X axis) 机械臂1的第二次改变姿态(绕其末端坐标系X轴转-pi/2)
%  Interpolation of the starting and ending poses of arm 1 to obtain all intermediate transitional poses (1*N2 cell array) 对机械臂1的起始姿态和终止姿态进行插值,得到中间所有的过渡姿态(1*N2元胞数组)
Arm1_R_end_Array_tmp = RPY_Interp(R1,Arm1_R_end,ed);  % First rotational attitude interpolation 第一次旋转姿态插值
Arm1_R_end_Array_tmp2 = RPY_Interp(Arm1_R_end,Arm1_R_end2,ed);   % Second rotational attitude interpolation 第二次旋转姿态插值
% Determine the sequence of pose matrix cells according to the time sequence of movements 根据运动时间先后,确定姿态矩阵元胞序列
for i = 1:(N1+N2+N3+N4+N)
    if i<=N1 %Panning process 平移过程
        Arm1_R_end_Array{i} = R1;
    elseif i>N1 && i<=N1+N2
        Arm1_R_end_Array{i} = Arm1_R_end_Array_tmp{i-N1};
    elseif i>N1+N2 && i<=N1+N2+N3
        Arm1_R_end_Array{i} = Arm1_R_end_Array_tmp{end};
    elseif i>N1+N2+N3 && i<=N1+N2+N3+N4
        Arm1_R_end_Array{i} = Arm1_R_end_Array_tmp2{i-(N1+N2+N3)};
    else
        Arm1_R_end_Array{i} = Arm1_R_end_Array_tmp2{end};
    end
end

% Calculating the meta-sequence of rotation matrix changes for robot arm 2 计算机械臂2的旋转矩阵变化的元胞序列
Arm2_R_end_Array = cell(1,N1+N2+N3+N4);   % Allocation of space 分配空间
Arm2_R_end_tmp = rpy2rotm(0,0,0,0,-pi/2,0);
Arm2_R_end_tmp2 = rpy2rotm(0,0,0,-pi/2,0,0);
Arm2_R_end = R1*Arm2_R_end_tmp(1:3,1:3);  % First change of attitude of robot arm 2 (-pi/2 around its end coordinate system Y axis) 机械臂2的第一次改变姿态(绕其末端坐标系Y轴转-pi/2)
Arm2_R_end2 = Arm2_R_end*Arm2_R_end_tmp2(1:3,1:3);  % Second change of attitude of robot arm 2 (-pi/2 around its end coordinate system X axis) 机械臂2的第二次改变姿态(绕其末端坐标系X轴转-pi/2)
%  Interpolation of the starting and ending poses of arm 2 to obtain all intermediate transitional poses (1*N2 cell array) 对机械臂2的起始姿态和终止姿态进行插值,得到中间所有的过渡姿态(1*N2元胞数组)
Arm2_R_end_Array_tmp = RPY_Interp(R1,Arm2_R_end,ed);  
Arm2_R_end_Array_tmp2 = RPY_Interp(Arm2_R_end,Arm2_R_end2,ed); 
% Determine the sequence of pose matrix cells according to the time sequence of movements 根据运动时间先后,确定姿态矩阵元胞序列
for i = 1:(N1+N2+N3+N4+N)
    if i<=N1+N2
        Arm2_R_end_Array{i} = R1;% Initial stance 初始姿态
    elseif i>N1+N2 && i<=N1+N2+N3
        Arm2_R_end_Array{i} = Arm2_R_end_Array_tmp{i-N1-N2};% It is the point at which N3 starts to be read 就是开始读取N3的点位
    elseif i>N1+N2+N3 && i<=N1+N2+N3+N4
        Arm2_R_end_Array{i} = Arm2_R_end_Array_tmp2{i-(N1+N2+N3)};% Start reading the points of the N4 开始读取N4的点位
    else
        Arm2_R_end_Array{i} = Arm2_R_end_Array_tmp2{end};
    end
end


Pc_neg = [-Pc(:,1),-Pc(:,2),Pc(:,3)];  % Available circular trajectory for robot arm 2 机械臂2可用的圆轨迹

P = [P0;P2;P2(end,:)+zeros(N2+N3,3);P4;Pc];     % Set of all trajectory points for robot arm 1 机械臂1所有轨迹点集合
Path2 = [A0+zeros(N1+N2,3);P3;Parm2_path2;Parm2_path2(end,:)+Pc_neg-Pc_neg(1,:)];   % Set of all trajectory points for robot arm 2 机械臂2所有轨迹点集合
Pt = [zeros(Ng,3);Pt1;Pt1(end,:)+zeros(N2+N3,3);Pt2;Pt2(end,:)+Pc-Pc(1,:)];    % Set of all track points of the square 方块所有轨迹点集合


t1 = (N1+N2)*0.1;% Panning time 平移时间
t2 = (N4+N)*0.1;% Collaboration time 协同时间
%%

% Coordinates of the square object at the beginning of the program run 方块物体在程序运行开始时的坐标
Tsq = [1 0 0 0.2-0.04/2;
       0 1 0 0.6-0.04/2;
       0 0 1 0.55-0.04/2;
       0 0 0 1];
%%
% Initial values of the two robotic arm joints 两机械臂关节初值
q0 = [get(handles.slider1, 'Value'),get(handles.slider3, 'Value'),get(handles.slider4, 'Value'),...
    get(handles.slider5, 'Value'),get(handles.slider6, 'Value'),get(handles.slider7, 'Value'),...
    get(handles.slider8, 'Value')]*pi/180;
q20 = q0;% Initial value of the joint of the second robot arm 第二个机械臂的关节初值

%% Based on the planned end trajectory and the selected pose, the inverse solution obtains the joint variables of both robotic arms 根据规划末端轨迹和选定姿态，逆解获得俩机械臂关节变量
for i=1:size(P,1)
    M = [Arm1_R_end_Array{i},P(i,:)';0 0 0 1]; % Left robotic arm position 左机械臂位姿
    M2 = [Arm2_R_end_Array{i},Path2(i,:)';0 0 0 1];
    Q(i,:) = NewtonRaphson_IK2(q0',M); % Equation for left robotic arm posture transition angle 左机械臂位姿转换角公式
    Qp2(i,:) = NewtonRaphson_IK2(q20',M2);
    q0 = Q(i,:); % Transfer 转置
    q20 = Qp2(i,:);
end
%%

q1 = Q(:,1);q2 = Q(:,2);q3 = Q(:,3);
q4 = Q(:,4);q5 = Q(:,5);q6 = Q(:,6);q7 = Q(:,7);% Robotic arm 1 for each position change angle 机械臂1各位姿转换角度

q1_2 = Qp2(:,1);q2_2 = Qp2(:,2);q3_2 = Qp2(:,3);
q4_2 = Qp2(:,4);q5_2 = Qp2(:,5);q6_2 = Qp2(:,6);q7_2 = Qp2(:,7);% Robotic arm 2 for each position change angle

%% Driving the movement of the robot arm 驱动机械臂运动
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

    
    % Overall coordinate changes 整体坐标变化
    Ts = [1 0 0 0;
          0 1 0 0;
          0 0 1 0;
          0 0 0 1];
    Ts2 = [-1 0 0 0.4;
           0 -1 0 0;
           0 0 1 0;
           0 0 0 1];
       
    %% Set the transformation matrix of the squares 设定方块的转换矩阵
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
    h(i)=plot3(PosAtt(1),PosAtt(2),PosAtt(3),'k.');  % Real-time plotting of the end trajectory of robot arm 1 实时绘制机械臂1末端轨迹
    
    pause(0.1)  % Time delay 延时
end
fprintf('Grabbing time：%.3f\n',t1);
fprintf('Moving time：%.3f\n',t2);
%%
    


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ta1
global Ttool
% Get slider joint variables 获取滑块关节变量
q1 = get(handles.slider1, 'Value')*pi/180;
q2 = get(handles.slider3, 'Value')*pi/180;
q3 = get(handles.slider4, 'Value')*pi/180;
q4 = get(handles.slider5, 'Value')*pi/180;
q5 = get(handles.slider6, 'Value')*pi/180;
q6 = get(handles.slider7, 'Value')*pi/180;
q7 = get(handles.slider8, 'Value')*pi/180;
d = get(handles.slider9, 'Value');

% Selecting the robot arm stance 选定机械臂姿态
[PosAtt,T1,T2,T3,T4,T5,T6,T7] = Franka_FK(q1,q2,q3,q4,q5,q6,q7,Ttool);
Ta1 = rpy2rotm(PosAtt(1),PosAtt(2),PosAtt(3),PosAtt(4),PosAtt(5),PosAtt(6)); % Movement matrix for robot arm 1 as a whole 机械臂1整体的运动矩阵
% disp(Ta1)
% R(Roll) 指绕X轴转的角度，P(Pitch) 指绕Y轴转的角度 Y(Yaw) 指绕Z轴转的角度

% Update slider values 更新滑块值
set(handles.slider1, 'Value',q1*180/pi);
set(handles.slider3, 'Value',q2*180/pi);
set(handles.slider4, 'Value',q3*180/pi);
set(handles.slider5, 'Value',q4*180/pi);
set(handles.slider6, 'Value',q5*180/pi);
set(handles.slider7, 'Value',q6*180/pi);
set(handles.slider8, 'Value',q7*180/pi);
set(handles.slider9, 'Value',d);
% Update slider display values 更新滑块显示值 
set(handles.text2, 'String', num2str(sprintf('%.1f', get(handles.slider1, 'Value'))));
set(handles.text3, 'String', num2str(sprintf('%.1f', get(handles.slider3, 'Value'))));
set(handles.text4, 'String', num2str(sprintf('%.1f', get(handles.slider4, 'Value'))));
set(handles.text5, 'String', num2str(sprintf('%.1f', get(handles.slider5, 'Value'))));
set(handles.text6, 'String', num2str(sprintf('%.1f', get(handles.slider6, 'Value'))));
set(handles.text7, 'String', num2str(sprintf('%.1f', get(handles.slider7, 'Value'))));
set(handles.text8, 'String', num2str(sprintf('%.1f', get(handles.slider8, 'Value'))));
set(handles.text9, 'String', num2str(sprintf('%.1f', get(handles.slider9, 'Value'))));

update(handles)
