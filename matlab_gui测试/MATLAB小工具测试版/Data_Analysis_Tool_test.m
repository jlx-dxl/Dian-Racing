function varargout = Data_Analysis_Tool_test(varargin)
% DATA_ANALYSIS_TOOL_TEST MATLAB code for Data_Analysis_Tool_test.fig
%      DATA_ANALYSIS_TOOL_TEST, by itself, creates a new DATA_ANALYSIS_TOOL_TEST or raises the existing
%      singleton*.
%


%      H = DATA_ANALYSIS_TOOL_TEST returns the handle to a new DATA_ANALYSIS_TOOL_TEST or the handle to
%     
%the existing singleton*.
%
%      DATA_ANALYSIS_TOOL_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_ANALYSIS_TOOL_TEST.M with the given input arguments.
%
%      DATA_ANALYSIS_TOOL_TEST('Property','Value',...) creates a new DATA_ANALYSIS_TOOL_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_Analysis_Tool_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_Analysis_Tool_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_Analysis_Tool_test

% Last Modified by GUIDE v2.5 31-Jan-2020 15:26:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Data_Analysis_Tool_test_OpeningFcn, ...
                   'gui_OutputFcn',  @Data_Analysis_Tool_test_OutputFcn, ...
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


% --- Executes just before Data_Analysis_Tool_test is made visible.���ڳ�������ʱ���Ϳ�ʼִ�С�
function Data_Analysis_Tool_test_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for Data_Analysis_Tool_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Data_Analysis_Tool_test_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FileSelection.
function FileSelection_Callback(hObject, eventdata, handles)
%filename��Ŵ򿪵��ļ���  pathname���·��
[filename,filepath]=uigetfile('*.mat','��ѡ���Գ�����');
%uigetfile(filter,title)
file=fullfile(filepath,filename);
%�õ��ַ�����ʽ�������ļ�·����
set(handles.FileDirectory,'String',file,'FontSize',10);
%set(H,Name,Value)
%���ļ�����Ŀ¼��ӡ������text��������ö�Ӧ����������Լ���ֵ
load(file);
vars=whos;
%whos�����г���ǰ�����ռ������б������Լ����ǵ����֡��ߴ磨����һ����������������ά��������ռ�ֽ��������Ե���Ϣ����Щ��Ϣ����ʾ��matlab�е�workspace�����С�
n=0;
for i=1:length(vars)
    try %���Ƿ���CAN�ź�
        eval([vars(i).name,'.unit;'])
        %���Է��ص�λ��vars(i).name����''��struct�������.unit;��'MCRL_ActualV_00_MCRL_ActualV_01.unit'
        n=n+1;
        List{n}=vars(i).name;
    catch
    end
%try
%     % ����ִ�е����E
%catch
%     % ���E���д���
%     % ִ��catch��end֮��Ĵ����
%end
end
set(handles.ParaList,'String',List);
%��������ѡ��Ŀ¼������Ϊlist

for i=1:length(List)
%��ӡĬ��ͼ��2����ΪĬ��ͼ�����������ʱ����Ϣ���ʵ�һ����ӡ��
    if strcmp(List{i}, 'MCRL_ActualV_01_MCRL_Diagnos_00')
        ErrorTime=[;];%������¼�����ʱ�伴����ŵľ���
        ParaName=List{i};
        axes(handles.Plot4)
        cla reset
        x=eval([ParaName,'.time;']);
        %x_Unit={'s'};
        y=eval([ParaName,'.signals.values;']);
        TimeBase=length(y);
        %y_Unit=eval([ParaName,'.unit;']);
        p1=plot(x,y);
        hold on;
        title('MCRL Diagnos','FontSize',8);
        %legend(p1,'MCRL Diagnos');
        %set(handles.Plot4text,'String',ParaName);
    end
    if strcmp(List{i}, 'MCRL_ActualV_01_MCRL_ErrorIn_01')
        ParaName=List{i};
        yErrorIn=eval([ParaName,'.signals.values;']);
    end
end
for m=2:length(y)%�ҳ�diagnostic�仯��һ�㲢����ErrorIn��ע
   n=m-1;
   if y(m)~=y(n)&&y(m)~=0
       str={['t:',num2str(x(m))],['Diagno:',num2str(y(m))],['ErrIn:',num2str(yErrorIn(m))]};
       text(x(m)+0.2,y(m)+1,str,'FontSize',8);%��������
       plot(x(m),y(m),'-o')%�������껭Բ��ע
       ErrorTime=[ErrorTime [m;y(m);yErrorIn(m)]];
       %��¼��������㼰��Ӧ��������������ͼ�ϱ�ע����ʱ��㣬���㷢�ִ���
       %******ע��******��mΪ��¼���꣬x(m)Ϊ��¼�����Ӧ��ʱ�䡣
       %��Ϊ��ʼʱ�䲻������plotʹ��ʵ��ʱ��x(m)�������㣬Ѱ��ֵʹ�ü�¼����m
   end
end

if ~isempty(ErrorTime)
    set(handles.text11,'BackgroundColor','red');%��Err������ɺ�ɫ����ʾErr
end

for i=1:length(List)%�õ�������ErrorTime
%��ӡĬ��ͼ��1    
    if strcmp(List{i}, 'MCRL_ActualV_00_MCRL_ActualV_01')
        ParaName=List{i};
        axes(handles.Plot3)
        cla reset
        x=eval([ParaName,'.time;']);
        %x_Unit={'s'};
        y=eval([ParaName,'.signals.values;']);
        y_Unit=eval([ParaName,'.unit;']);
        plot(x,y)
        hold on
        if ~isempty(ErrorTime)%��Ϊ����ִ��
            ratio=floor(length(y)/TimeBase);%�������ݲɼ��ܶ�ת��ʱ�������
            stem(x(ratio.*ErrorTime(1,:)),y(ratio.*ErrorTime(1,:)));%��ΪErrorTime��һ�д洢�����������꣬x()���Ǵ洢��ʱ��
            for n=1:length(ErrorTime(1,:))
                str={['t:',num2str(x(ratio.*ErrorTime(1,n)))],[ y_Unit,':',num2str(y(ratio.*ErrorTime(1,n)))],...
                    ['Diagno:',num2str(ErrorTime(2,n)),'-',num2str(ErrorTime(3,n))]};
                text(x(ratio.*ErrorTime(1,n))+0.2,y(ratio.*ErrorTime(1,n))+1,str,'FontSize',8);%��������,'Color',[0 0.4470 0.7410]
            end
        end
        title('MCRL ActualV','FontSize',8);
    end

    %��ӡĬ��ͼ��3
    if strcmp(List{i}, 'MCRL_ActualV_00_MCRL_ActualT_00')
        ParaName=List{i};
        axes(handles.Plot5)
        cla reset%���ͼ��
        x=eval([ParaName,'.time;']);
        %x_Unit={'s'};
        y=eval([ParaName,'.signals.values;']);
        y_Unit=eval([ParaName,'.unit;']);
        plot(x,y)
        hold on
        if ~isempty(ErrorTime)%��Ϊ����ִ��
            ratio=floor(length(y)/TimeBase);%�������ݲɼ��ܶ�ת��ʱ�������
            stem(x(ratio.*ErrorTime(1,:)),y(ratio.*ErrorTime(1,:)));%5msȡֵһ�Σ���ΪErrorTime��һ�д洢�����������꣬x()���Ǵ洢��ʱ��
            for n=1:length(ErrorTime(1,:))
                str={['t:',num2str(x(ratio.*ErrorTime(1,n)))],[ y_Unit,':',num2str(y(ratio.*ErrorTime(1,n)))],...
                    ['Diagno:',num2str(ErrorTime(2,n)),'-',num2str(ErrorTime(3,n))]};
                text(x(ratio.*ErrorTime(1,n))+0.2,y(ratio.*ErrorTime(1,n))+1,str,'FontSize',8);%��������,'Color',[0 0.4470 0.7410]
            end
        end
        title('MCRL ActualT','FontSize',8);
    end
end
handles.TimeRange=y(end)+1;
handles.ErrorTime=ErrorTime;
handles.TimeBase=TimeBase;%�ѱ����洢�����
p1={};p2={};
handles.Plot1plots=p1;%������cell�����ڼ�¼ÿһ��plot�ľ������������stem����legend
handles.Plot2plots=p2;
guidata(hObject,handles);%�������ı��
%keyboard %ȡ��ע�Ϳ����������ж�ʹ��command window���в���
set(handles.text12,'String',['���ݽ���ʱ��',num2str(handles.TimeRange),'s']);%��ʾ�Գ�����ʱ��


% --- Executes on selection change in SelectedParaList.
function SelectedParaList_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function SelectedParaList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%��ʼ��ʱ������ɫ������


% --- Executes on selection change in ParaList.
function ParaList_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns ParaList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ParaList


% --- Executes during object creation, after setting all properties.
function ParaList_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotButton.
function PlotButton_Callback(hObject, eventdata, handles)
%��������
file=get(handles.FileDirectory,'String');
%get��ѯͼ�ζ�������
load(file);
%��ѡ��ģ������õ�ѡ��ı���
String=get(handles.ParaList,'String');
%Paralist�����е�cell array
Index=get(handles.ParaList,'Value');
%ȡ��Paralistѡ�е���һ����Ӧ��ֵ   
ParaName=String{Index};
%ȡ�������ַ���
%��SelectedParaList�����ݽ��д���
List=get(handles.SelectedParaList,'String');
%һ����ѡ������ݵ�cell
List{length(List)+1}=ParaName;

set(handles.SelectedParaList,'String',List)

for i=1:length(List)
index=strfind(List{i},'_');
tmp=List{i};
Name{i}=tmp(index(end-1)+1:index(end)-1);
end
Name=strrep(Name,'_',' ');
%��1�е�3����2

axes(handles.Plot1)
p1=handles.Plot1plots;
%p1=get(handles.Plot1plots,'none');
x=eval([ParaName,'.time;']);
%x_Unit={'s'};
y=eval([ParaName,'.signals.values;']);
y_Unit=eval([ParaName,'.unit;']);
p=plot(x,y);
p1{length(p1)+1}=p;
handles.Plot1plots=p1;
guidata(hObject,handles);%�������ı��
%set(handles.Plot1plots,'none',p1);
%keyboard
hold on
ErrorTime=handles.ErrorTime;
TimeBase=handles.TimeBase;
%keyboard
if ~isempty(ErrorTime)
    ratio=floor(length(y)/TimeBase);%�������ݲɼ��ܶ�ת��ʱ�������
    stem(x(ratio.*ErrorTime(1,:)),y(ratio.*ErrorTime(1,:)));
    for n=1:length(ErrorTime(1,:))
        str={['t:',num2str(x(ratio.*ErrorTime(1,n)))],[ y_Unit,':',num2str(y(ratio.*ErrorTime(1,n)))]};
        text(x(ratio.*ErrorTime(1,n))+0.2,y(ratio.*ErrorTime(1,n))+1,str,'FontSize',8);%��������,'Color',[0 0.4470 0.7410]
    end
end
legend([p1{:}],Name);
%legend��ÿ����¼�µ�plot���ƥ��һ��Name���б�ע��
%legend��һ��ֻʶ������[]��ʽ�µ�plot������ʽ�cell����������[]װ����


% --- Executes on button press in ClearPlot.
function ClearPlot_Callback(hObject, eventdata, handles)
axes(handles.Plot1)
cla reset
set(handles.SelectedParaList,'String','')

% --- Executes during object creation, after setting all properties.
function Plot1_CreateFcn(hObject, eventdata, handles)
% set(hObject,'toolbar','figure') 


% Hint: place code in OpeningFcn to populate Plot1


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)


% --- Executes on selection change in SelectedParaList2.
function SelectedParaList2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function SelectedParaList2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotButton2.
function PlotButton2_Callback(hObject, eventdata, handles)
%��������
file=get(handles.FileDirectory,'String');
load(file);
%��ѡ��ģ������õ�ѡ��ı���
String=get(handles.ParaList,'String');
Index=get(handles.ParaList,'Value');
ParaName=String{Index};

axes(handles.Plot2)
p2=handles.Plot2plots;
x=eval([ParaName,'.time;']);
%x_Unit={'s'};
y=eval([ParaName,'.signals.values;']);
y_Unit=eval([ParaName,'.unit;']);
p=plot(x,y);
p2{length(p2)+1}=p;
handles.Plot2plots=p2;
guidata(hObject,handles);%�������ı��
hold on;
ErrorTime=handles.ErrorTime;
TimeBase=handles.TimeBase;
%keyboard
if ~isempty(ErrorTime)
    ratio=floor(length(y)/TimeBase);%�������ݲɼ��ܶ�ת��ʱ�������
    stem(x(ratio.*ErrorTime(1,:)),y(ratio.*ErrorTime(1,:)));
    for n=1:length(ErrorTime(1,:))
        str={['t:',num2str(x(ratio.*ErrorTime(1,n)))],[ y_Unit,':',num2str(y(ratio.*ErrorTime(1,n)))]};
        text(x(ratio.*ErrorTime(1,n))+0.2,y(ratio.*ErrorTime(1,n))+1,str,'FontSize',8);%��������,'Color',[0 0.4470 0.7410]
    end
end
%��SelectedParaList�����ݽ��д���
List=get(handles.SelectedParaList2,'String');
List{length(List)+1}=ParaName;
set(handles.SelectedParaList2,'String',List);

for i=1:length(List)
index=strfind(List{i},'_');
tmp=List{i};
Name{i}=tmp(index(end-1)+1:index(end)-1);
end
Name=strrep(Name,'_',' ');
legend([p2{:}],Name);
%��ע�ź�����

% --- Executes on button press in ClearPlot2.
function ClearPlot2_Callback(hObject, eventdata, handles)
axes(handles.Plot2)
cla reset
set(handles.SelectedParaList2,'String','')

function Start_Time_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Start_Time_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function End_Time_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function End_Time_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
TimeRange=handles.TimeRange;
StartTimeRaw=get(handles.Start_Time,'String');
EndTimeRaw=get(handles.End_Time,'String');
%�������default����ʾ��ʼplot��Χ
if strcmp(StartTimeRaw, 'DEFAULT') || strcmp(StartTimeRaw, 'Default') || strcmp(StartTimeRaw, 'default')
    StartTime=0;
else
    StartTime=str2double(StartTimeRaw);
end
if strcmp(EndTimeRaw, 'DEFAULT') || strcmp(EndTimeRaw, 'Default') || strcmp(EndTimeRaw, 'default')
    EndTime=TimeRange;
else
    EndTime=str2double(EndTimeRaw);
end
axes(handles.Plot1)
xlim([StartTime,EndTime]);
axes(handles.Plot2)
xlim([StartTime,EndTime]);
axes(handles.Plot3)
xlim([StartTime,EndTime]);
axes(handles.Plot4)
xlim([StartTime,EndTime]);
axes(handles.Plot5)
xlim([StartTime,EndTime]);


% --- Executes during object creation, after setting all properties.
function PlotButton_CreateFcn(hObject, eventdata, handles)

% --- Executes during object deletion, before destroying properties.
function PlotButton_DeleteFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function text11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
