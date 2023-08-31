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

%% ĩ������ϵ�͹�������ϵ��ת������
Ttool = [1 0 0 0;
         0 1 0 0;
         0 0 1 0.207;
         0 0 0 1];
%%
% add other workpath
addpath('Fanka_STL');
addpath('Tool_functions');

% End arrow coordinate data ĩ�˼�ͷ��������
a = 0.005/3;  % Radius of the arrow tail cylinder ��βԲ���뾶
b = 0.3/3;    % Length of arrow tail cylinder ��βԲ������
c = 0.04/3;    % Radius of arrow circle ��ͷԲ��뾶 
d = 0.1/3;    % Height from the round face of the arrow to the top of the cone ��ͷԲ����׶�����ĸ߶�
N = 100;    % Number of dense arrow mesh data points ��ͷmesh�����ܼ������

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
daspect([1 1 1]);% Sets the data aspect ratio for the current coordinate area ���õ�ǰ�����������ݳ����
light('Position', [0 0 5]);
light('Position', [2 2 1]);
axis equal
grid on
xlabel('X')
ylabel('Y');
zlabel('Z');
rotate3d on  % Rotation of elements using the 3D engine ʹ��3D�����Ԫ�ؽ�����ת 
view(50, 20);% View Perspectives �鿴�ӽ�

% Build the transformation matrix for the first robot arm ������һ����е�۵�ת����ξ���
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

% Create a transformation matrix of square objects �������������ת����ξ���
handles.Square = hgtransform('Tag', 'Square');

% Build the conversion matrix for the second robot arm�����ڶ�����е�۵�ת����ξ���
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

%% Importing the STL model of robot arm 1 �����е��1��STLģ��
% Base components ��������
[V,F] = stlRead( 'link0.stl' );
patch('Faces',F,'Vertices',V, ...
    'EdgeAlpha', 0,'Parent', handles.plane) % EdgeAlpha ��͸����
% link1 ����1
[V,F] = stlRead( 'link1.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring1);
% link2 ����2
[V,F] = stlRead( 'link2.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring2);
% link3 ����3
[V,F] = stlRead( 'link3.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring3);
% link4 ����4
[V,F] = stlRead( 'link4.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring4);
% link5 ����5
[V,F] = stlRead( 'link5.stl' );
patch('Faces', F, 'Vertices', V, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring5);
% link6 ����6
[V,F] = stlRead( 'link6.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring6);
% link7 ����7
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
% End arrow coordinate axis Z ĩ�˼�ͷ������Z
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.Z);
% End arrow coordinate axis Y ĩ�˼�ͷ������Y
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.Y);
% End arrow coordinate axis X ĩ�˼�ͷ������X
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'r', 'EdgeAlpha', 0,'Parent', handles.X);
%%

%% Cube object coordinate system ������������ϵ
[V,F] = squareplot(length,width,high);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', [0.5,0.5,0.5], 'EdgeAlpha', 0,'Parent', handles.Square);
%%

%% Importing the STL model of robot arm 2 �����е��2��STLģ��
% Base components ��������
[V,F] = stlRead( 'link0.stl' );
patch('Faces',F,'Vertices',V, ...
    'EdgeAlpha', 0,'Parent', handles.plane_2)
% link1 ����1
[V,F] = stlRead( 'link1.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring1_2);
% link2 ����2
[V,F] = stlRead( 'link2.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring2_2);
% link3 ����3
[V,F] = stlRead( 'link3.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring3_2);
% link4 ����4
[V,F] = stlRead( 'link4.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring4_2);
% link5 ����5
[V,F] = stlRead( 'link5.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.ring5_2);
% link6 ����6
[V,F] = stlRead( 'link6.stl' );
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.ring6_2);
% link7 ����7
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
% End arrow coordinate axis Z ĩ�˼�ͷ������Z
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'b', 'EdgeAlpha', 0,'Parent', handles.Z_2);
% End arrow coordinate axis Y ĩ�˼�ͷ������Y
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'g', 'EdgeAlpha', 0,'Parent', handles.Y_2);
% End arrow coordinate axis X ĩ�˼�ͷ������X
[V,F] = arrowplot(a,b,c,d,N);
patch('Faces', F, 'Vertices', V*1, ...
    'FaceColor', 'r', 'EdgeAlpha', 0,'Parent', handles.X_2);
%%


% set the initial value of text fields ��GUT�Ļ�����б��
set(handles.text2, 'String', num2str(sprintf('%.1f', get(handles.slider1, 'Value'))));% num2str ������ת��Ϊ�ַ�����
set(handles.text3, 'String', num2str(sprintf('%.1f', get(handles.slider3, 'Value'))));% ���handle˵���˾��Ǳ��
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
% Get the angle value of each joint of the slider ��ȡ������ؽڽǶ�ֵ
q1 = get(handles.slider1, 'Value')*pi/180;
q2 = get(handles.slider3, 'Value')*pi/180;
q3 = get(handles.slider4, 'Value')*pi/180;
q4 = get(handles.slider5, 'Value')*pi/180;
q5 = get(handles.slider6, 'Value')*pi/180;
q6 = get(handles.slider7, 'Value')*pi/180;
q7 = get(handles.slider8, 'Value')*pi/180;
d = get(handles.slider9, 'Value');
[PosAtt,T1,T2,T3,T4,T5,T6,T7] = Franka_FK(q1,q2,q3,q4,q5,q6,q7,Ttool);   % Calculating positive solutions, rotation matrix �������⣬��ת����

ang = -pi/4;
T8 = rpy2rotm(0,0,0.107,0,0,ang);

T91 = rpy2rotm(0,0,0.0584,0,0,0);
T92 = rpy2rotm(0,0,0.0584,0,0,0)*rpy2rotm(0,0,0,0,0,pi);

% End jaw conversion matrix ĩ�˿�צת������
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

% Starting coordinates of the two robotic arms ����е����ʼ����
Ts = [1 0 0 0;
      0 1 0 0;
      0 0 1 0;
      0 0 0 1];
Ts2 = [-1 0 0 0.4;
      0 -1 0 0;
      0 0 1 0;
      0 0 0 1];
  
%  Overall coordinate change of the square object ����������������仯
Tsq = [1 0 0 0.2-0.04/2;
       0 1 0 0.6-0.04/2;
       0 0 1 0.55-0.04/2;
       0 0 0 1];

%% Set the transition matrix for the first robot arm �趨��һ����е�۵�ת������
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

%% Set the conversion matrix for the second robot arm �趨�ڶ�����е�۵�ת������
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

%% Set the transformation matrix of the squares �趨�����ת������
set(handles.Square, 'Matrix', Tsq);
%%

% Positioning pose display module �趨λ����ʾģ��
set(handles.text15, 'string', num2str(roundn(PosAtt(1),-3))); %PosAtt(1)-(6)����ָ����RPY XYZ GUI���ϱ�
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
R1 = Ta1(1:3,1:3);   % Initial attitude matrix for robotic arms 1 and 2 ��е��1��2�ĳ�ʼ��̬����(3*3)
thetaC = 0:et:2*pi;% Selecting track points ѡȡ�켣��λ
N = size(thetaC,2);
R = 0.2;     % Radius �뾶
h = 0.2;    % Lifting height ̧���߶�

%% Two robotic arms, end-of-square trajectory planning ����е�ۡ�����ĩ�˹켣�滮
A0 = [Ta1(1,4),Ta1(2,4),Ta1(3,4)];   % starting position of robotic arm 1 ��е��1��ʼλ��
A01 = [0.2,0.6,0.55];    % Arm 1 moves to the point where the object was originally located ��е��1�˶������ԭ�����ڵĵ�
A2 = [Ta1(1,4), -Ta1(2,4)+0.2, Ta1(3,4)]; % Robot arm 2 moves to the start of the circular trajectory ��е��2�ƶ���Բ�ι켣�����
P0 = Interpolation(A0,A01,ed);    % Robotic arm 1 via point of assembly 1 ��е��1·���㼯��1
P2 = Interpolation(A01,A0+[0,-0.2,0],ed);  % Robotic arm 1 via point of assembly 2 ��е��1·���㼯��2

Pf1 = A01;    % Square relative to the start of the world coordinate system �����������������ϵ���
Pf2 = A0 + [0,-0.2,0];    % Square path point 2 ����·����2
Parm2 = [A2(1)-(A2(1)-0.2)*2,A2(2),A2(3)];   % Robotic arm 2 path point 2 ��е��2·����2
P3 = Interpolation(A0,Parm2,ed); % Robotic arm 2 via point of assembly 1 ��е��2·���㼯��1

Pfk1 = Pf2-Pf1;  % Translational path of the square �����ƽ��·��
Pt1 = Interpolation([0,0,0],Pfk1,ed);   % Set of square waypoints1 (trajectory with respect to the starting point) ����·���㼯��1(�������ʼ���˶��켣)
N1 = size([P0;P2],1);% All points of robot arm 1 before it moves to a circular trajectory ��е��1���˶���Բ�ι켣ǰ�����е�λ
Ng = size(P0,1);% Robot arm 1 moves to all points of the starting point of the square ��е��1�ƶ����������ʼ������е�λ
N2 = Ng;
N3 = size(P3,1);%Translational path points for robot arm 2 ��е��2��ƽ��·����λ

%% Lifted section ̧������
Pfk2 = Pfk1 + [-(R+0.01),0,h];  % Square relative path point 3 �������·����3.........R+0.01
Parm3 = Parm2 + [R+0.01,0,h];   % Robotic arm 2 path point 3 ��е��2·����3........R+0.01
A3 = Pf2 + [-(R+0.01),0,h];   % Robotic arm 1 path point 3, circle start ��е��1·����3��Բ���............R+0.01
Pt2 = Interpolation(Pfk1,Pfk2,ed);  %  Square Waypoint Collection 2 ����·���㼯��2
P4 = Interpolation(Pf2,A3,ed);   %  Robotic arm 1 Waypoint collection 4 ��е��1·���㼯��4
Parm2_path2 = Interpolation(Parm2,Parm3,ed);  % Robotic arm 2 via point collection 2 ��е��2·���㼯��2
N4 = size(P4,1);% Upward path points ����·����λ

%% ��ʼ��Բ
Pc0 = A3;  % Start of circular trajectory Բ�켣���  [0.2351,-0.0027,0.4903+0.3]
C = [Pc0(1)-R,Pc0(2)+R,Pc0(3)];   % Center of circle Բ��..........R+0.01
yc = C(2)+R*(sin(thetaC)-1);  % y-trajectory of robot arm 1 ��е��1��y�켣
xc = C(1)-R*(cos(thetaC)-1)+R;  % x-trajectory of robot arm 1 ��е��1��x�켣
zc = C(3).*ones(1,N);  % z-trajectory of robot arm 1 ��е��1��z�켣
Pc = [xc',yc',zc'];% Overall circular trajectory of robot arm 1 ��е��1������Բ�켣

% Calculate the meta-sequence of rotation matrix changes for robot arm 1 �����е��1����ת����仯��Ԫ������
Arm1_R_end_Array = cell(1,N1+N2+N3+N4);   % Allocate tuple space ����Ԫ������ռ�
Arm1_R_end_tmp = rpy2rotm(0,0,0,0,-pi/2,0);  % Calculating the chi-square matrix ������ξ���(4*4)
Arm1_R_end_tmp2 = rpy2rotm(0,0,0,-pi/2,0,0);
Arm1_R_end = R1*Arm1_R_end_tmp(1:3,1:3);  % First change of attitude of robot arm 1 (turn -pi/2 around its end coordinate system Y axis) ��е��1�ĵ�һ�θı���̬(����ĩ������ϵY��ת-pi/2)
Arm1_R_end2 = Arm1_R_end*Arm1_R_end_tmp2(1:3,1:3);  % Second change of attitude of robot arm 1 (-pi/2 around its end coordinate system X axis) ��е��1�ĵڶ��θı���̬(����ĩ������ϵX��ת-pi/2)
%  Interpolation of the starting and ending poses of arm 1 to obtain all intermediate transitional poses (1*N2 cell array) �Ի�е��1����ʼ��̬����ֹ��̬���в�ֵ,�õ��м����еĹ�����̬(1*N2Ԫ������)
Arm1_R_end_Array_tmp = RPY_Interp(R1,Arm1_R_end,ed);  % First rotational attitude interpolation ��һ����ת��̬��ֵ
Arm1_R_end_Array_tmp2 = RPY_Interp(Arm1_R_end,Arm1_R_end2,ed);   % Second rotational attitude interpolation �ڶ�����ת��̬��ֵ
% Determine the sequence of pose matrix cells according to the time sequence of movements �����˶�ʱ���Ⱥ�,ȷ����̬����Ԫ������
for i = 1:(N1+N2+N3+N4+N)
    if i<=N1 %Panning process ƽ�ƹ���
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

% Calculating the meta-sequence of rotation matrix changes for robot arm 2 �����е��2����ת����仯��Ԫ������
Arm2_R_end_Array = cell(1,N1+N2+N3+N4);   % Allocation of space ����ռ�
Arm2_R_end_tmp = rpy2rotm(0,0,0,0,-pi/2,0);
Arm2_R_end_tmp2 = rpy2rotm(0,0,0,-pi/2,0,0);
Arm2_R_end = R1*Arm2_R_end_tmp(1:3,1:3);  % First change of attitude of robot arm 2 (-pi/2 around its end coordinate system Y axis) ��е��2�ĵ�һ�θı���̬(����ĩ������ϵY��ת-pi/2)
Arm2_R_end2 = Arm2_R_end*Arm2_R_end_tmp2(1:3,1:3);  % Second change of attitude of robot arm 2 (-pi/2 around its end coordinate system X axis) ��е��2�ĵڶ��θı���̬(����ĩ������ϵX��ת-pi/2)
%  Interpolation of the starting and ending poses of arm 2 to obtain all intermediate transitional poses (1*N2 cell array) �Ի�е��2����ʼ��̬����ֹ��̬���в�ֵ,�õ��м����еĹ�����̬(1*N2Ԫ������)
Arm2_R_end_Array_tmp = RPY_Interp(R1,Arm2_R_end,ed);  
Arm2_R_end_Array_tmp2 = RPY_Interp(Arm2_R_end,Arm2_R_end2,ed); 
% Determine the sequence of pose matrix cells according to the time sequence of movements �����˶�ʱ���Ⱥ�,ȷ����̬����Ԫ������
for i = 1:(N1+N2+N3+N4+N)
    if i<=N1+N2
        Arm2_R_end_Array{i} = R1;% Initial stance ��ʼ��̬
    elseif i>N1+N2 && i<=N1+N2+N3
        Arm2_R_end_Array{i} = Arm2_R_end_Array_tmp{i-N1-N2};% It is the point at which N3 starts to be read ���ǿ�ʼ��ȡN3�ĵ�λ
    elseif i>N1+N2+N3 && i<=N1+N2+N3+N4
        Arm2_R_end_Array{i} = Arm2_R_end_Array_tmp2{i-(N1+N2+N3)};% Start reading the points of the N4 ��ʼ��ȡN4�ĵ�λ
    else
        Arm2_R_end_Array{i} = Arm2_R_end_Array_tmp2{end};
    end
end


Pc_neg = [-Pc(:,1),-Pc(:,2),Pc(:,3)];  % Available circular trajectory for robot arm 2 ��е��2���õ�Բ�켣

P = [P0;P2;P2(end,:)+zeros(N2+N3,3);P4;Pc];     % Set of all trajectory points for robot arm 1 ��е��1���й켣�㼯��
Path2 = [A0+zeros(N1+N2,3);P3;Parm2_path2;Parm2_path2(end,:)+Pc_neg-Pc_neg(1,:)];   % Set of all trajectory points for robot arm 2 ��е��2���й켣�㼯��
Pt = [zeros(Ng,3);Pt1;Pt1(end,:)+zeros(N2+N3,3);Pt2;Pt2(end,:)+Pc-Pc(1,:)];    % Set of all track points of the square �������й켣�㼯��


t1 = (N1+N2)*0.1;% Panning time ƽ��ʱ��
t2 = (N4+N)*0.1;% Collaboration time Эͬʱ��
%%

% Coordinates of the square object at the beginning of the program run ���������ڳ������п�ʼʱ������
Tsq = [1 0 0 0.2-0.04/2;
       0 1 0 0.6-0.04/2;
       0 0 1 0.55-0.04/2;
       0 0 0 1];
%%
% Initial values of the two robotic arm joints ����е�۹ؽڳ�ֵ
q0 = [get(handles.slider1, 'Value'),get(handles.slider3, 'Value'),get(handles.slider4, 'Value'),...
    get(handles.slider5, 'Value'),get(handles.slider6, 'Value'),get(handles.slider7, 'Value'),...
    get(handles.slider8, 'Value')]*pi/180;
q20 = q0;% Initial value of the joint of the second robot arm �ڶ�����е�۵Ĺؽڳ�ֵ

%% Based on the planned end trajectory and the selected pose, the inverse solution obtains the joint variables of both robotic arms ���ݹ滮ĩ�˹켣��ѡ����̬�����������е�۹ؽڱ���
for i=1:size(P,1)
    M = [Arm1_R_end_Array{i},P(i,:)';0 0 0 1]; % Left robotic arm position ���е��λ��
    M2 = [Arm2_R_end_Array{i},Path2(i,:)';0 0 0 1];
    Q(i,:) = NewtonRaphson_IK2(q0',M); % Equation for left robotic arm posture transition angle ���е��λ��ת���ǹ�ʽ
    Qp2(i,:) = NewtonRaphson_IK2(q20',M2);
    q0 = Q(i,:); % Transfer ת��
    q20 = Qp2(i,:);
end
%%

q1 = Q(:,1);q2 = Q(:,2);q3 = Q(:,3);
q4 = Q(:,4);q5 = Q(:,5);q6 = Q(:,6);q7 = Q(:,7);% Robotic arm 1 for each position change angle ��е��1��λ��ת���Ƕ�

q1_2 = Qp2(:,1);q2_2 = Qp2(:,2);q3_2 = Qp2(:,3);
q4_2 = Qp2(:,4);q5_2 = Qp2(:,5);q6_2 = Qp2(:,6);q7_2 = Qp2(:,7);% Robotic arm 2 for each position change angle

%% Driving the movement of the robot arm ������е���˶�
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

    
    % Overall coordinate changes ��������仯
    Ts = [1 0 0 0;
          0 1 0 0;
          0 0 1 0;
          0 0 0 1];
    Ts2 = [-1 0 0 0.4;
           0 -1 0 0;
           0 0 1 0;
           0 0 0 1];
       
    %% Set the transformation matrix of the squares �趨�����ת������
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
    h(i)=plot3(PosAtt(1),PosAtt(2),PosAtt(3),'k.');  % Real-time plotting of the end trajectory of robot arm 1 ʵʱ���ƻ�е��1ĩ�˹켣
    
    pause(0.1)  % Time delay ��ʱ
end
fprintf('Grabbing time��%.3f\n',t1);
fprintf('Moving time��%.3f\n',t2);
%%
    


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ta1
global Ttool
% Get slider joint variables ��ȡ����ؽڱ���
q1 = get(handles.slider1, 'Value')*pi/180;
q2 = get(handles.slider3, 'Value')*pi/180;
q3 = get(handles.slider4, 'Value')*pi/180;
q4 = get(handles.slider5, 'Value')*pi/180;
q5 = get(handles.slider6, 'Value')*pi/180;
q6 = get(handles.slider7, 'Value')*pi/180;
q7 = get(handles.slider8, 'Value')*pi/180;
d = get(handles.slider9, 'Value');

% Selecting the robot arm stance ѡ����е����̬
[PosAtt,T1,T2,T3,T4,T5,T6,T7] = Franka_FK(q1,q2,q3,q4,q5,q6,q7,Ttool);
Ta1 = rpy2rotm(PosAtt(1),PosAtt(2),PosAtt(3),PosAtt(4),PosAtt(5),PosAtt(6)); % Movement matrix for robot arm 1 as a whole ��е��1������˶�����
% disp(Ta1)
% R(Roll) ָ��X��ת�ĽǶȣ�P(Pitch) ָ��Y��ת�ĽǶ� Y(Yaw) ָ��Z��ת�ĽǶ�

% Update slider values ���»���ֵ
set(handles.slider1, 'Value',q1*180/pi);
set(handles.slider3, 'Value',q2*180/pi);
set(handles.slider4, 'Value',q3*180/pi);
set(handles.slider5, 'Value',q4*180/pi);
set(handles.slider6, 'Value',q5*180/pi);
set(handles.slider7, 'Value',q6*180/pi);
set(handles.slider8, 'Value',q7*180/pi);
set(handles.slider9, 'Value',d);
% Update slider display values ���»�����ʾֵ 
set(handles.text2, 'String', num2str(sprintf('%.1f', get(handles.slider1, 'Value'))));
set(handles.text3, 'String', num2str(sprintf('%.1f', get(handles.slider3, 'Value'))));
set(handles.text4, 'String', num2str(sprintf('%.1f', get(handles.slider4, 'Value'))));
set(handles.text5, 'String', num2str(sprintf('%.1f', get(handles.slider5, 'Value'))));
set(handles.text6, 'String', num2str(sprintf('%.1f', get(handles.slider6, 'Value'))));
set(handles.text7, 'String', num2str(sprintf('%.1f', get(handles.slider7, 'Value'))));
set(handles.text8, 'String', num2str(sprintf('%.1f', get(handles.slider8, 'Value'))));
set(handles.text9, 'String', num2str(sprintf('%.1f', get(handles.slider9, 'Value'))));

update(handles)
