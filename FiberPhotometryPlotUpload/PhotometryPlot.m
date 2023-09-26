function varargout = PhotometryPlot(varargin)
% PHOTOMETRYPLOT MATLAB code for PhotometryPlot.fig
%      PHOTOMETRYPLOT, by itself, creates a new PHOTOMETRYPLOT or raises the existing
%      singleton*.
%
%      H = PHOTOMETRYPLOT returns the handle to a new PHOTOMETRYPLOT or the handle to
%      the existing singleton*.
%
%      PHOTOMETRYPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PHOTOMETRYPLOT.M with the given input arguments.
%
%      PHOTOMETRYPLOT('Property','Value',...) creates a new PHOTOMETRYPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PhotometryPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PhotometryPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PhotometryPlot

% Last Modified by GUIDE v2.5 05-Aug-2021 15:47:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PhotometryPlot_OpeningFcn, ...
    'gui_OutputFcn',  @PhotometryPlot_OutputFcn, ...
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


% --- Executes just before PhotometryPlot is made visible.
function PhotometryPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PhotometryPlot (see VARARGIN)

% Choose default command line output for PhotometryPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PhotometryPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PhotometryPlot_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=getlastfile('*.csv;*.mat','Open Fiber File',0);
if pathname==0
    return
end
dotind=strfind(filename,'.');
filetype=filename(dotind(end)+1:end);

if filetype=='csv' 
    ExcelData=xlsread([pathname,filename]);
    %% Sample frequency
    if ~isempty(get(handles.edit2,'String'))
        SampleFrequency=str2num(get(handles.edit2,'String'));
    else
        SampleFrequency=inputdlg('Enter SampleFrequency,e.g.100 ','SampleFrequency');
        SampleFrequency=str2num(SampleFrequency{1});
        set(handles.edit2,'String',num2str(SampleFrequency));
    end
    if ~isempty(get(handles.edit3,'String'))
        offset=str2num(get(handles.edit3,'String'));
    else
        offset=inputdlg('Enter offset,e.g.1.00 ','offset');
        offset=str2num(offset{1});
        set(handles.edit3,'String',num2str(offset));
    end
    Fiber.ff475.offset=offset(1);
    Fiber.ff570.offset=offset(2);
    SampleInterval=1/SampleFrequency;
    SampleTotaltime=size(ExcelData,1)/SampleFrequency;
    xtime=0:SampleInterval:SampleTotaltime-SampleInterval;
    %% Channel information
    Fiber.ff475.SampleFrequency=SampleFrequency;
    Fiber.ff570.SampleFrequency=SampleFrequency;
    Event.channel.level=ExcelData(:,1);
    Fiber.ff475.value=ExcelData(:,4);
    Fiber.ff570.value=ExcelData(:,5);
    
elseif filetype=='mat'
    load([pathname,filename]);
    %% get Event
    EventTitle={'lick','footshock','laser','hypoxia','optogenetics','N2','event'};
    [eventori,eventName]=getEvent([pathname,filename],EventTitle); %get Event Channel data;
    if isfield(eventori,'times')
        
        if isfield(eventori,'level')
            eventori.times=reshape(eventori.times,2,[]);
            eventori.on=eventori.times(1,:);
            eventori.off=eventori.times(2,:);
            
        else
            eventori.values=zeros(size(ff475.values));
            eventori.on=eventori.times;
            eventori.off=eventori.on+0.1;
        end
        eventori.on=round(eventori.on/ff475.interval);
        eventori.off=round(eventori.off/ff475.interval);
        
        eventori.values=zeros(size(ff475.values));
        eventori.interval=ff475.interval;
        for i=1:length(eventori.on)
            eventori.values(eventori.on(i):eventori.off(i))=1;
        end
    end
    Event.channel.level=round(eventori.values);
    Event.channel.interval=eventori.interval;
    Event.channel.title=eventName;
    %% Sample frequency
    if all(~(diff([ff475.interval,ff570.interval])))==1
        SampleFrequency=1/ff475.interval;
    end
    set(handles.edit2,'String',num2str(SampleFrequency));
    
    if ~isempty(get(handles.edit3,'String'))
        offset=str2num(get(handles.edit3,'String'));
    else
        offset=inputdlg('Enter offset,e.g.1.00 ','offset');
        offset=str2num(offset{1});
        set(handles.edit3,'String',num2str(offset));
    end
    Fiber.ff475.offset=offset(1);
    Fiber.ff570.offset=offset(2);
    SampleInterval=1/SampleFrequency;
    
    if all(~(diff([ff475.length,ff570.length])))==1
        
        SampleTotaltime=ff475.length/SampleFrequency;
    else
        
        minLength=min([ff475.length,ff570.length]);
        ff475.values(minLength+1:end)=[];
        ff570.values(minLength+1:end)=[];
        SampleTotaltime=minLength/1000;
        
    end
    len475=length(ff475.values);
    len570=length(ff570.values);
    xtime=linspace(0,SampleTotaltime,len475);
    
    
    %% Channel information
    Fiber.ff475.SampleFrequency=SampleFrequency;
    Fiber.ff570.SampleFrequency=SampleFrequency;
    
    
    
    Fiber.ff475.value=ff475.values;
    Fiber.ff570.value=ff570.values;
    Fiber.ff475.interval=ff475.interval;
    Fiber.ff570.interval=ff570.interval;
    
end
colorpool.ff475 = [0.2, 0.6275, 0.1725];
colorpool.ff570 = [1, 0, 0];
colorpool.cyan = [0.3010, 0.7450, 0.9330];
colorpool.gray1 = [.7 .7 .7];
colorpool.gray2 = [.8 .8 .8];
figure('name','rwa data');
subplot(3,1,1) %ff475 channel
plot(xtime,Fiber.ff475.value,'color',colorpool.ff475);
xlim([0,xtime(end)]);
subplot(3,1,2) %ff570 channel
plot(xtime,Fiber.ff570.value,'color',colorpool.ff570);
xlim([0,xtime(end)]);
subplot(3,1,3)%event channel
try
    plot(xtime,Event.channel.level,'color',colorpool.cyan)
    xlim([0,xtime(end)]);
catch
end
Fiber.xtime=xtime;

setappdata(handles.pushbutton1,'Event',Event);
setappdata(handles.pushbutton1,'Fiber',Fiber);
setappdata(handles.pushbutton1,'colorpool',colorpool);
setappdata(handles.pushbutton1,'filename',filename);
setappdata(handles.pushbutton1,'pathname',pathname);

%  filetag=filename(1:end-4);
%  save([pathname,filetag,'pushbutton1.mat'],'Event','Fiber','filename');
Eventtype={'Footshcok';'Lick';'Optogenetics';'Hypoxia'};
set(handles.popupmenu1,'String',Eventtype);
set(handles.radiobutton1,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.edit1,'String',filename);




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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename=getappdata(handles.pushbutton1,'filename');
pathname=getappdata(handles.pushbutton1,'pathname');
Event=getappdata(handles.pushbutton1,'Event');
Fiber=getappdata(handles.pushbutton1,'Fiber');
colorpool=getappdata(handles.pushbutton1,'colorpool');
Eventtype=get(handles.popupmenu1,'String');
CurrentEvent=get(handles.popupmenu1,'Value');
Event.name=Eventtype{CurrentEvent};

xtime=Fiber.xtime;
if ~isempty(get(handles.edit4,'String'))
    tmin=str2num(get(handles.edit4,'String'));
else
    tmin=inputdlg('Enter start point time,e.g.100 ','start point time');
    tmin=str2num(tmin{1});
    set(handles.edit4,'String',num2str(tmin));
end
indmin = find(xtime>=tmin,1);


if ~isempty(get(handles.edit5,'String'))
    switch get(handles.edit5,'String')
        case 'max'
            tmax=xtime(end);
        case 'Max'
            tmax=xtime(end);
        case 'MAX'
            tmax=xtime(end);
        otherwise
            tmax=str2num(get(handles.edit5,'String'));
    end
elseif isempty(get(handles.edit5,'String'))
    tmax=inputdlg('Enter stop point time,e.g.max ','stop time');
    switch tmax{1}
        case 'max'
            tmax=xtime(end);set(handles.edit5,'String','max');
        case 'Max'
            tmax=xtime(end);set(handles.edit5,'String','max');
        case 'MAX'
            tmax=xtime(end);set(handles.edit5,'String','max');
        otherwise
            tmax=str2num(tmax{1});set(handles.edit5,'String',num2str(tmax));
    end
end

indmax = find(xtime>=tmax,1); % find max index of when time crosses threshold
xtime = xtime(indmin:indmax);
Fiber.ff475.value=Fiber.ff475.value(indmin:indmax);
Fiber.ff570.value=Fiber.ff570.value(indmin:indmax);
Event.channel.level=Event.channel.level(indmin:indmax);


if get(handles.checkbox1,'value')==1
    figure('name','2nd_order_exp_fit')
    
    [fit475, gof] = ffExpFit(Fiber.ff475.value);
    plot(xtime,Fiber.ff475.value,'color',colorpool.ff475);
    hold on;
    x = 1:length(Fiber.ff475.value);
    plot(xtime,fit475(x),'color',[1,0,0],'LineWidth',2);
    xlabel('Time (min/s)');
    ylabel('volt');
    hold on;
    Fiber.ff475.value=Fiber.ff475.value-fit475(x)+min(fit475(x));
    plot(xtime,Fiber.ff475.value,'color',0.8*(colorpool.ff475));
    
    [fit570, gof] = ffExpFit(Fiber.ff570.value);
    plot(xtime,Fiber.ff570.value,'color',colorpool.ff570);
    hold on;
    x = 1:length(Fiber.ff570.value);
    plot(xtime,fit570(x),'color',[1,0,0],'LineWidth',2);
    xlabel('Time (min/s)');
    ylabel('volt');
    hold on;
    Fiber.ff570.value=Fiber.ff570.value-fit570(x)+min(fit570(x));
    plot(xtime,Fiber.ff570.value,'color',0.8*(colorpool.ff570));
    
end

if get(handles.checkbox3,'value')==1
    try
        load([pathname,'fitIndex.mat']);
        ax=fitIndex{1};
    catch
        ax=inputdlg('Enter exp2 a0-a4,e.g.1 2 3 4 5 ','exp2 parameter ff475');
        ax=str2num(ax{1});
    end
    x=(indmin:indmax)*Fiber.ff475.interval;
    y=exp2f(x,ax(1),ax(2),ax(3),ax(4),ax(5));
    
    xtime=(0:length(Fiber.ff475.value)-1)*Fiber.ff475.interval;
    figure('name','ff475signal')
    plot(xtime,Fiber.ff475.value,'color',colorpool.ff475);
    hold on;
    plot(xtime,y,'color',[1,0,0],'LineWidth',2);
    xlabel('Time (min)');
    ylabel('volt');
    Fiber.ff475.value=Fiber.ff475.value-y+min(y);
    Fiber.ff475.base=min(y);
    try
        bx=fitIndex{2};
    catch
        bx=inputdlg('Enter exp2 a0-a4,e.g.1 2 3 4 5 ','exp2 parameter ff570');
        bx=str2num(bx{1});
    end
    x=(indmin:indmax)*Fiber.ff570.interval;
    y=exp2f(x,bx(1),bx(2),bx(3),bx(4),bx(5));
    
    xtime=(0:length(Fiber.ff570.value)-1)*Fiber.ff570.interval;
    figure('name','ff570signal')
    plot(xtime,Fiber.ff570.value,'color',colorpool.ff570);
    hold on;
    plot(xtime,y,'color',[1,0,0],'LineWidth',2);
    xlabel('Time (min)');
    ylabel('volt');
    Fiber.ff570.value=Fiber.ff570.value-y+min(y);
    Fiber.ff570.base=min(y);
    
    fitIndex{1}=ax;
    fitIndex{2}=bx;
    save([pathname,'fitIndex.mat'],'fitIndex');
end

if ~isfield(Fiber.ff475,'base')
    Fiber.ff475.base=min(Fiber.ff475.value);
end

if ~isfield(Fiber.ff570,'base')
    Fiber.ff570.base=min(Fiber.ff570.value);
end




Fiber.ff475.dFF=(Fiber.ff475.value-Fiber.ff475.base)/(Fiber.ff475.base-Fiber.ff475.offset);
Fiber.ff570.dFF=(Fiber.ff570.value-Fiber.ff570.base)/(Fiber.ff570.base-Fiber.ff570.offset);

figure('name','remove meaningless data');
ha = tight_subplot(3,1,[.03 .03],[.1 .01],[.1 .01]);
axes(ha(1));
plot(xtime/60,Fiber.ff475.dFF,'color',colorpool.ff475);
xlim([min(xtime/60),max(xtime/60)]);
set(gca,'TickDir','out');
axis tight
set(gca,'box','off','xtick',[]);
ha(1).XAxis.Visible = 'off';
set(gca,'box','off');
set(gca,'color','none');

axes(ha(2));
plot(xtime/60,Fiber.ff570.dFF,'color',colorpool.ff570);
xlim([min(xtime/60),max(xtime/60)]);
set(gca,'TickDir','out');
axis tight
set(gca,'box','off','xtick',[]);
ha(2).XAxis.Visible = 'off';
set(gca,'box','off');
set(gca,'color','none');
axes(ha(3));
plot(xtime/60,Event.channel.level,'color','k')
xlim([min(xtime/60),max(xtime/60)]);
set(gca,'TickDir','out');
% axis tight
set(gca,'box','off');
set(gca,'color','none');
ylim([0.2,1]);
xlabel('Time(min)');
set(gcf,'renderer','painters')
filetag=filename(1:end-4);
if ~isempty(get(handles.edit11,'String'))
    treatment=get(handles.edit11,'String');
else
    treatment=inputdlg('Enter treatment,e.g.saline or drug ','treatment');
    treatment=treatment{1};
end
saveas(gcf, [pathname,filetag,treatment,'dFFfig.fig']);
saveas(gcf, [pathname,filetag,treatment,'dFFpdf.pdf']);


Fiber.xtime=xtime;

if ~isempty(get(handles.edit6,'String'))
    basetime=str2num(get(handles.edit6,'String'));
else
    basetime=2.5;
    set(handles.edit6,'String',num2str(basetime));
end
if ~isempty(get(handles.edit7,'String'))
    pretime=str2num(get(handles.edit7,'String'));
else
    pretime=2.5;
    set(handles.edit7,'String',num2str(pretime));
end
if ~isempty(get(handles.edit8,'String'))
    posttime=str2num(get(handles.edit8,'String'));
else
    posttime=10;
    set(handles.edit8,'String',num2str(posttime));
end


SampleFrequency=Fiber.ff475.SampleFrequency;
SampleInterval=1/SampleFrequency;
Fiber.basetime=basetime;
Fiber.pretime=pretime;
Fiber.posttime=posttime;

xtime=Fiber.xtime;


switch get(handles.popupmenu1,'Value')
    case 1
        %% footshock time
        Event.(Event.name).level=Event.channel.level;
        eventleveldiff=diff(Event.(Event.name).level);
        Event.(Event.name).on=find(eventleveldiff==1)+1;
        Event.(Event.name).off=find(eventleveldiff==-1)+1;
        trialtotalnum=length(Event.(Event.name).on);
        Eventpulse=mean((Event.(Event.name).off-Event.(Event.name).on)*SampleInterval);
        Fiber.ff475.value=Fiber.ff475.value-Fiber.ff475.offset;
        Fiber.ff570.value=Fiber.ff570.value-Fiber.ff570.offset;
        baseind=Event.(Event.name).on-round((basetime+pretime)*SampleFrequency);
        preind=Event.(Event.name).on-round((pretime)*SampleFrequency);
        postind=Event.(Event.name).on+round((posttime)*SampleFrequency);
        if get(handles.radiobutton1,'value')
            for trialno=1:trialtotalnum
                greedbaseF(trialno)=mean(Fiber.ff475.value(baseind(trialno):preind(trialno)));
                Fiber.ff475.deltaFratio(trialno,:)=(Fiber.ff475.value(baseind(trialno):postind(trialno))-greedbaseF(trialno))/greedbaseF(trialno);
                ff570baseF(trialno)=mean(Fiber.ff570.value(baseind(trialno):preind(trialno)));
                Fiber.ff570.deltaFratio(trialno,:)=(Fiber.ff570.value(baseind(trialno):postind(trialno))-ff570baseF(trialno))/ff570baseF(trialno);
            end
        elseif get(handles.radiobutton2,'value')
            for trialno=1:trialtotalnum
                greedbaseF(trialno)=mean(Fiber.ff475.value(baseind(trialno):preind(trialno)));
                Fiber.ff475.deltaFratio(trialno,:)=(Fiber.ff475.value(baseind(trialno):postind(trialno))-greedbaseF(trialno))/std(Fiber.ff475.value(baseind(trialno):postind(trialno)));
                ff570baseF(trialno)=mean(Fiber.ff570.value(baseind(trialno):preind(trialno)));
                Fiber.ff570.deltaFratio(trialno,:)=(Fiber.ff570.value(baseind(trialno):postind(trialno))-ff570baseF(trialno))/std(Fiber.ff570.value(baseind(trialno):postind(trialno)));
            end
        end
        
        %% ff475 pre post
        ff475length=size(Fiber.ff475.deltaFratio,2);
        ff475premean=mean(Fiber.ff475.deltaFratio(:,1:round(ff475length*(pretime+basetime)/(pretime+basetime+posttime))),2);
        ff475postmean=mean(Fiber.ff475.deltaFratio(:,round(ff475length*(pretime+basetime)/(pretime+basetime+posttime)):end),2);
        Fiber.ff475.premean=ff475premean;
        Fiber.ff475.postmean=ff475postmean;
        peri_time=-1*(pretime+basetime):SampleInterval:posttime;
        
        figure('name',Event.name,'position',[1,41,1366,650])
        subplot(2,3,1)
        p1=plot(peri_time,Fiber.ff475.deltaFratio','color',colorpool.gray1);
        hold on
        yEvent=get(gca,'Ylim');
        l1= plot([0,0],yEvent,'k');
        plot([Eventpulse,Eventpulse],yEvent,'k');
        p2=plot(peri_time,mean(Fiber.ff475.deltaFratio),'color',colorpool.ff475);
        xx = [peri_time, fliplr(peri_time)];
        yy = [mean(Fiber.ff475.deltaFratio) + std(Fiber.ff475.deltaFratio),...
            fliplr(mean(Fiber.ff475.deltaFratio) - std(Fiber.ff475.deltaFratio))];
        h = fill(xx, yy, 'g'); % plot this first for overlay purposes
        legend([l1, p1(1), p2, h],{'footshock','Trial Traces','Mean Response','Std'},'location','northeast','Box','off');
        hold on;
        set(h, 'facealpha', 0.25, 'edgecolor', 'none');
        xlabel('Time from current onset','fontsize',16)
        ylabel('dF/F','fontsize',16);
        title('Peri-Event Trial Responses','fontsize',16);
        axis tight;
        subplot(2,3,2)
        imagesc(Fiber.ff475.deltaFratio);
        colormap(jet);
        colorbar;
        set(gca,'XTick',linspace(1,ff475length,length(peri_time(1):1:peri_time(end))));
        set(gca,'XTickLabel',peri_time(1):1:peri_time(end));
        
        
        set(gca,'YTick',1:size(Fiber.ff475.deltaFratio,1));
        title('Footshock Heat Map','fontsize',16)
        ylabel('Trial Number','fontsize',16)
        xlabel('Time from current onset','fontsize',16)
        
        
        ff475mean=[mean(ff475premean),mean(ff475postmean)];
        ff475std=[std(ff475premean),std(ff475postmean)];
        subplot(2,3,3)
        hbar=bar([1,2],ff475mean);
        hbar.FaceColor=[1 1 1];
        hold on;
        herr=errorbar([1,2],ff475mean,ff475std);
        herr.LineStyle='none';
        hold on;
        scatter(ones(size(ff475premean)),ff475premean);
        hold on;
        scatter(ones(size(ff475postmean))*2,ff475postmean);
        hold on;
        plot([ff475premean,ff475postmean]');
        set(gca,'TickDir','out');
        set(gcf,'Renderer','painters');
        set(gca,'XTickLabel',{'Pre','post'});
        ylabel('dF/F');
        
        %% ff570 pre post
        ff570length=size(Fiber.ff570.deltaFratio,2);
        ff570premean=mean(Fiber.ff570.deltaFratio(:,1:round(ff570length*(pretime+basetime)/(pretime+basetime+posttime))),2);
        ff570postmean=mean(Fiber.ff570.deltaFratio(:,round(ff570length*(pretime+basetime)/(pretime+basetime+posttime)):end),2);
        Fiber.ff570.premean=ff570premean;
        Fiber.ff570.postmean=ff570postmean;
        subplot(2,3,4)
        p1=plot(peri_time,Fiber.ff570.deltaFratio','color',colorpool.gray1);
        hold on
        yEvent=get(gca,'Ylim');
        l1=plot([0,0],yEvent,'k');
        plot([Eventpulse,Eventpulse],yEvent,'k');
        p2=plot(peri_time,mean(Fiber.ff570.deltaFratio),'color',colorpool.ff475);
        xx = [peri_time, fliplr(peri_time)];
        yy = [mean(Fiber.ff570.deltaFratio) + std(Fiber.ff570.deltaFratio),...
            fliplr(mean(Fiber.ff570.deltaFratio) - std(Fiber.ff570.deltaFratio))];
        h = fill(xx, yy, 'r'); % plot this first for overlay purposes
        legend([l1, p1(1), p2, h],{'footshock','Trial Traces','Mean Response','Std'},'location','northeast','Box','off');
        hold on;
        set(h, 'facealpha', 0.25, 'edgecolor', 'none');
        xlabel('Time from current onset','fontsize',16)
        ylabel('dF/F','fontsize',16);
        title('Peri-Event Trial Responses','fontsize',16);
        axis tight;
        subplot(2,3,5)
        imagesc(Fiber.ff570.deltaFratio);
        colormap(jet);
        colorbar;
        set(gca,'XTick',linspace(1,ff570length,length(peri_time(1):1:peri_time(end))));
        set(gca,'XTickLabel',peri_time(1):1:peri_time(end));
        set(gca,'YTick',1:size(Fiber.ff570.deltaFratio,1));
        title('Footshock Heat Map','fontsize',16)
        ylabel('Trial Number','fontsize',16)
        xlabel('Time from current onset','fontsize',16)
        
        
        
        ff570mean=[mean(ff570premean),mean(ff570postmean)];
        ff570std=[std(ff570premean),std(ff570postmean)];
        subplot(2,3,6)
        hbar=bar([1,2],ff570mean);
        hbar.FaceColor=[1 1 1];
        hold on;
        herr=errorbar([1,2],ff570mean,ff570std);
        herr.LineStyle='none';
        hold on;
        scatter(ones(size(ff570premean)),ff570premean);
        hold on;
        scatter(ones(size(ff570postmean))*2,ff570postmean);
        hold on;
        plot([ff570premean,ff570postmean]');
        set(gca,'TickDir','out');
        set(gcf,'Renderer','painters');
        set(gca,'XTickLabel',{'Pre','post'});
        ylabel('dF/F');
        Fiber.ff475.heatmap.value=Fiber.ff475.deltaFratio;
        Fiber.ff570.heatmap.value=Fiber.ff570.deltaFratio;
        filetag=filename(1:end-4);
        %         saveas(gcf,[pathname,filetag,'.pdf']);
        %         saveas(gcf,[pathname,filetag,'.jpg']);
        if ~isempty(get(handles.edit11,'String'))
            treatment=get(handles.edit11,'String');
        else
            treatment=inputdlg('Enter Ca signal treatment,e.g.saline ','treatment');
            treatment=treatment{1};
        end
        Fiber.ff475.heatmap.average=mean(Fiber.ff475.heatmap.value);
        Fiber.ff570.heatmap.average=mean(Fiber.ff570.heatmap.value);
        
        Fiber.ff475.heatmap.xtime=linspace(-1*(Fiber.basetime+Fiber.pretime),Fiber.posttime,length(Fiber.ff475.heatmap.value))';
        Fiber.ff570.heatmap.xtime=linspace(-1*(Fiber.basetime+Fiber.pretime),Fiber.posttime,length(Fiber.ff570.heatmap.value))';
        
        
        
        save([pathname,filetag,'footshock_',treatment,'.mat'],'Event','Fiber','filename','peri_time');
        set(handles.edit11,'String',[treatment,'done']);
        
    case 2
        Fiber.ff475.value=Fiber.ff475.value-Fiber.ff475.offset;
        Fiber.ff570.value=Fiber.ff570.value-Fiber.ff570.offset;
        
        BOUT_TIME_THRESHOLD = 10; % example bout time threshold, in seconds
        MIN_LICK_THRESH = 10; % four licks or more make a bout
        Event.lick.level=round(Event.channel.level);
        TIMEarg=[basetime,pretime,posttime];
        
        %% lick time
        lickleveldiff=diff(Event.lick.level);
        Event.lick.on=xtime(find(lickleveldiff==1)+1);
        Event.lick.off=xtime(find(lickleveldiff==-1)+1);
        trialtotalnum=length(Event.lick.on);
        figure('name','ff475-ff570 channel');
        subplot(2,1,1)
        plot(xtime,Fiber.ff475.value,'color',colorpool.ff475);
        hold on;
        ylimrang=get(gca,'ylim');
        shiftlevel(find(Event.lick.level==0))=ylimrang(1);
        shiftlevel(find(Event.lick.level==1))=ylimrang(1)+(ylimrang(2)-ylimrang(1))*0.2;
        plot(xtime,shiftlevel,'color',colorpool.cyan);
        xlim([0,xtime(end)]);
        
        subplot(2,1,2)
        plot(xtime,Fiber.ff570.value,'color',colorpool.ff570);
        hold on;
        ylimrang=get(gca,'ylim');
        shiftlevel(find(Event.lick.level==0))=ylimrang(1);
        shiftlevel(find(Event.lick.level==1))=ylimrang(1)+(ylimrang(2)-ylimrang(1))*0.2;
        plot(xtime,shiftlevel,'color',colorpool.cyan);
        xlim([0,xtime(end)]);
        
        
        
        LICK_on = Event.lick.on;
        LICK_off = Event.lick.off;
        LICK_x = reshape(kron([LICK_on, LICK_off], [1, 1])', [], 1);
        sz = length(LICK_on);
        Event.lick.data=ones(sz,1);
        d = Event.lick.data';
        y_scale = 1; %adjust according to data needs
        y_shift = -0.20; %scale and shift are just for asthetics
        LICK_y = reshape([zeros(1, sz); d; d; zeros(1, sz)], 1, []);
        
        %% Find differences in onsets and threshold for major difference indices
        lick_on_diff = diff(Event.lick.on);
        lick_diff_ind = find(lick_on_diff >= BOUT_TIME_THRESHOLD);
        
        % Make an onset/ offset array based on threshold indices
        
        diff_ind_i = 1;
        for i = 1:length(lick_diff_ind)
            % BOUT onset is thresholded onset index of lick epoc event
            Event.lick_bouts.on(i) = Event.lick.on(diff_ind_i);
            % BOUT offset is thresholded offset of lick event before next onset
            Event.lick_bouts.off(i) = Event.lick.off(lick_diff_ind(i));
            Event.lick_bouts.data(i) = 1; % set the data value, arbitrary 1
            diff_ind_i = lick_diff_ind(i) + 1; % increment the index
        end
        
        %         filetag=filename(1:end-4);
        %         save([pathname,filetag,'pushbutton2.mat'],'Event','Fiber','filename');
        
        
        % Special case for last event to handle lick event offset indexing
        Event.lick_bouts.on = [Event.lick_bouts.on,Event.lick.on(lick_diff_ind(end)+1)];
        Event.lick_bouts.off = [Event.lick_bouts.off,Event.lick.off(end)];
        Event.lick_bouts.data = [Event.lick_bouts.data, 1];
        % Transpose the arrays to make them column vectors like other epocs
        Event.lick_bouts.on = Event.lick_bouts.on';
        Event.lick_bouts.off = Event.lick_bouts.off';
        Event.lick_bouts.data = Event.lick_bouts.data';
        %%
        % Now determine if it was a 'real' bout or not by thresholding by some
        % user-set number of licks in a row
        licks_array = zeros(length(Event.lick_bouts.on),1);
        for i = 1:length(Event.lick_bouts.on)
            % Find number of licks in licks_array between onset ond offset of
            % Our new lick BOUT (LICK_EVENT)
            licks_array(i) = numel(find(Event.lick.on >=Event.lick_bouts.on(i) & Event.lick.on <=Event.lick_bouts.off(i)));
        end
        
        %%
        % Remove onsets, offsets, and data of thrown out events. Matlab can use
        % booleans for indexing. Cool!
        Event.lick_bouts.on((licks_array < MIN_LICK_THRESH)) = [];
        Event.lick_bouts.off((licks_array < MIN_LICK_THRESH)) = [];
        Event.lick_bouts.data((licks_array < MIN_LICK_THRESH)) = [];
        LICK_EVENT_on = Event.lick_bouts.on;
        LICK_EVENT_off = Event.lick_bouts.off;
        LICK_EVENT_x = reshape(kron([LICK_EVENT_on,LICK_EVENT_off],[1, 1])',[],1);
        sz = length(LICK_EVENT_on);
        d = Event.lick_bouts.data';
        LICK_EVENT_y = reshape([zeros(1, sz); d; d; zeros(1, sz)], 1, []);
        
        %%
        % Next step: dFF with newly defined lick bouts
        figure('name','ff475&lick_bounts')
        subplot(2,1,1)
        p1 = plot(xtime, Fiber.ff475.value,'Color',colorpool.ff475,'LineWidth',2);
        hold on;
        title('ff475','fontsize',16);
        ylimrang=get(gca,'ylim');
        shiftlevel2(find(LICK_EVENT_y==0))=ylimrang(1);
        shiftlevel2(find(LICK_EVENT_y==1))=ylimrang(1)+(ylimrang(2)-ylimrang(1))*0.2;
        p2=plot(LICK_EVENT_x,shiftlevel2','color',colorpool.cyan);
        xlim([0,xtime(end)]);
        legend([p1 p2],'Green', 'Lick Bout');
        axis tight
        subplot(2,1,2)
        p1 = plot(xtime, Fiber.ff570.value,'Color',colorpool.ff570,'LineWidth',2);
        hold on;
        title('ff570','fontsize',16);
        ylimrang=get(gca,'ylim');
        shiftlevel2(find(LICK_EVENT_y==0))=ylimrang(1);
        shiftlevel2(find(LICK_EVENT_y==1))=ylimrang(1)+(ylimrang(2)-ylimrang(1))*0.2;
        p2=plot(LICK_EVENT_x,shiftlevel2','color',colorpool.cyan);
        xlim([0,xtime(end)]);
        legend([p1 p2],'ff570', 'Lick Bout');
        axis tight
        
        
        %%
        % Making nice area fills instead of epocs for asthetics. Newer versions of
        % Matlab can use alpha on area fills, which could be desirable
        figure('name','ff475_lick_bount_patch')
        subplot(2,1,1)
        hold on;
        dFF_min = min(Fiber.ff475.value);
        dFF_max = max(Fiber.ff475.value);
        for i = 1:numel(Event.lick_bouts.on)
            h1(i) = area([Event.lick_bouts.on(i) ...
                Event.lick_bouts.off(i)], [dFF_max dFF_max], ...
                dFF_min, 'FaceColor',colorpool.cyan,'edgecolor', 'none');
        end
        p1 = plot(xtime, Fiber.ff475.value,'Color',colorpool.ff475,'LineWidth',2);
        title('ff475_lick_bounts','fontsize',16);
        legend([p1 h1(1)],'Green', 'Lick Bout');
        ylabel('uV','fontsize',16)
        xlabel('Seconds','fontsize',16);
        axis tight
        subplot(2,1,2)
        hold on;
        dFF_min = min(Fiber.ff570.value);
        dFF_max = max(Fiber.ff570.value);
        for i = 1:numel(Event.lick_bouts.on)
            h2(i) = area([Event.lick_bouts.on(i) ...
                Event.lick_bouts.off(i)], [dFF_max dFF_max], ...
                dFF_min, 'FaceColor',colorpool.cyan,'edgecolor', 'none');
        end
        p2 = plot(xtime, Fiber.ff570.value,'Color',colorpool.ff570,'LineWidth',2);
        title('ff570_lick_bounts','fontsize',16);
        legend([p2 h2(1)],'ff570', 'Lick Bout');
        ylabel('uV','fontsize',16)
        xlabel('Seconds','fontsize',16);
        axis tight
        %% Time Filter Around Lick Bout Epocs
        % Note that we are using dFF of the full time-series, not peri-event dFF
        % where f0 is taken from a pre-event baseline period. That is done in
        % another fiber photometry data analysis example.
        
        % time span for peri-event filtering, PRE and POST
        TRANGE = [-1*(pretime+basetime)*floor(SampleFrequency),-1*pretime*floor(SampleFrequency),posttime*floor(SampleFrequency)];
        
        %%
        % Pre-allocate memory
        trials = numel(Event.lick_bouts.on);
        F_snipsff475 = cell(trials,1);
        Base_snipsff475=cell(trials,1);
        F_snipsff570 = cell(trials,1);
        Base_snipsff570=cell(trials,1);
        array_ind = zeros(trials,1);
        pre_stim = zeros(trials,1);
        post_stim = zeros(trials,1);
        %%
        % Make stream snips based on trigger onset
        for i = 1:trials
            % If the bout cannot include pre-time seconds before event, make zero
            if Event.lick_bouts.on(i) < (pretime+basetime)
                F_snipsff475{i} = single(zeros(1,(TRANGE(3)-TRANGE(1))));
                continue
            else
                % Find first time index after bout onset
                array_ind(i) = find(xtime > Event.lick_bouts.on(i),1);
                % Find index corresponding to pre and post stim durations
                base_stim(i)=array_ind(i) + TRANGE(1);
                pre_stim(i) = array_ind(i) + TRANGE(2);
                post_stim(i) = array_ind(i) + TRANGE(3);
                F_snipsff475{i} = Fiber.ff475.value(base_stim(i):post_stim(i))';% from base time to post time
                Base_snipsff475{i}=Fiber.ff475.value(base_stim(i):pre_stim(i))';
                F_snipsff570{i} = Fiber.ff570.value(base_stim(i):post_stim(i))';
                Base_snipsff570{i}=Fiber.ff570.value(base_stim(i):pre_stim(i))';
            end
        end
        
        %%
        % Make all snippet cells the same size based on minimum snippet length
        minLength = min(cellfun('prodofsize', F_snipsff475));
        F_snipsff475 = cellfun(@(x) x(1:minLength), F_snipsff475, 'UniformOutput',false);
        % Convert to a matrix and get mean
        allSignalsff475 = cell2mat(F_snipsff475);
        allbaseff475=mean(cell2mat(Base_snipsff475)');
        allff475std=std(allSignalsff475');
        allff475stdmatrix=repmat(allff475std',1,size(allSignalsff475,2));
        allbaseff475matrix=repmat(allbaseff475',1,size(allSignalsff475,2));
        if get(handles.radiobutton1,'value')
            allSignalsff475=(allSignalsff475-allbaseff475matrix)./allbaseff475matrix; %df/f
        elseif get(handles.radiobutton2,'value')
            
            
            allSignalsff475=(allSignalsff475-allbaseff475matrix)./allff475stdmatrix; %z-score
            
            
        end
        
        mean_allSignalsff475 = mean(allSignalsff475);
        std_allSignalsff475 = std(mean_allSignalsff475);
        
        % Make a time vector snippet for peri-events
        peri_time = (1:length(mean_allSignalsff475))/SampleFrequency - pretime;
        
        %ff570
        minLength = min(cellfun('prodofsize', F_snipsff570));
        F_snipsff570 = cellfun(@(x) x(1:minLength), F_snipsff570, 'UniformOutput',false);
        % Convert to a matrix and get mean
        allSignalsff570 = cell2mat(F_snipsff570);
        allbaseff570=mean(cell2mat(Base_snipsff570)');
        allff570std=std(allSignalsff570');
        allff570stdmatrix=repmat(allff570std',1,size(allSignalsff570,2));
        allbaseff570matrix=repmat(allbaseff570',1,size(allSignalsff570,2));
        if get(handles.radiobutton1,'value')
            allSignalsff570=(allSignalsff570-allbaseff570matrix)./allbaseff570matrix;%df/f
        elseif get(handles.radiobutton2,'value')
            allSignalsff570=(allSignalsff570-allbaseff570matrix)./allff570stdmatrix;%z-score
        end
        mean_allSignalsff570 = mean(allSignalsff570);
        std_allSignalsff570 = std(mean_allSignalsff570);
        
        % Make a time vector snippet for peri-events
        peri_time = (1:length(mean_allSignalsff570))/SampleFrequency - (pretime+basetime);
        %% Make a Peri-Event Stimulus Plot and Heat Map
        
        % Make a standard deviation fill for mean signal
        figure('Position',[100, 100, 500, 550])
        subplot(2,2,1)
        xx = [peri_time, fliplr(peri_time)];
        yy = [mean_allSignalsff475 + std_allSignalsff475,...
            fliplr(mean_allSignalsff475 - std_allSignalsff475)];
        h = fill(xx, yy, 'g'); % plot this first for overlay purposes
        hold on;
        set(h, 'facealpha', 0.25, 'edgecolor', 'none');
        
        % Set specs for min and max value of event line.
        % Min and max of either std or one of the signal snip traces
        linemin = min(min(min(allSignalsff475)),min(yy));
        linemax = max(max(max(allSignalsff475)),max(yy));
        
        % Plot the line next
        l1 = line([0 0], [linemin, linemax],...
            'color','cyan', 'LineStyle', '-', 'LineWidth', 2);
        % Plot the signals and the mean signal
        % p1 = plot(peri_time, allSignalsff475', 'color', gray1);
        p1= plot(peri_time, allSignalsff475','color',colorpool.gray1);
        p2 = plot(peri_time, mean_allSignalsff475, 'color', colorpool.ff475, 'LineWidth', 3);
        hold off;
        
        % Make a legend and do other plot things
        legend([l1, p1(1), p2, h],...
            {'Lick Onset','Trial Traces','Mean Response','Std'},...
            'Location','northeast');
        title('Peri-Event Trial Responses','fontsize',16);
        ylabel('dF/F','fontsize',16);
        xlabel('Time from lick onset (s)','fontsize',16)
        
        axis tight;
        % Make an invisible colorbar so this plot aligns with one below it
        temp_cb = colorbar('Visible', 'off');
        
        % Heat map
        subplot(2,2,2)
        imagesc(peri_time, 1, allSignalsff475); % this is the heatmap
        set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
        colormap(jet) % colormap otherwise defaults to perula
        title('Lick Bout Heat Map','fontsize',16)
        ylabel('Trial Number','fontsize',16)
        xlabel('Time from lick onset (s)','fontsize',16)
        cb = colorbar;
        %         ylabel(cb, 'dFF','fontsize',16)
        axis tight;
        
        subplot(2,2,3)
        xx = [peri_time, fliplr(peri_time)];
        yy = [mean_allSignalsff570 + std_allSignalsff570,...
            fliplr(mean_allSignalsff570 - std_allSignalsff570)];
        h = fill(xx, yy, 'r'); % plot this first for overlay purposes
        hold on;
        set(h, 'facealpha', 0.25, 'edgecolor', 'none');
        
        % Set specs for min and max value of event line.
        % Min and max of either std or one of the signal snip traces
        linemin = min(min(min(allSignalsff570)),min(yy));
        linemax = max(max(max(allSignalsff570)),max(yy));
        
        % Plot the line next
        l1 = line([0 0], [linemin, linemax],...
            'color','cyan', 'LineStyle', '-', 'LineWidth', 2);
        % Plot the signals and the mean signal
        % p1 = plot(peri_time, allSignalsff570', 'color', gray1);
        
        p1=  plot(peri_time, allSignalsff570','color',colorpool.gray1);
        
        p2 = plot(peri_time, mean_allSignalsff570, 'color', colorpool.ff570, 'LineWidth', 3);
        hold off;
        
        % Make a legend and do other plot things
        legend([l1, p1(1), p2, h],...
            {'Lick Onset','Trial Traces','Mean Response','Std'},...
            'Location','northeast');
        title('Peri-Event Trial Responses','fontsize',16);
        ylabel('dF/F','fontsize',16);
        xlabel('Time from lick onset (s)','fontsize',16)
        
        axis tight;
        % Make an invisible colorbar so this plot aligns with one below it
        temp_cb = colorbar('Visible', 'off');
        
        % Heat map
        subplot(2,2,4)
        imagesc(peri_time, 1, allSignalsff570); % this is the heatmap
        set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
        colormap(jet) % colormap otherwise defaults to perula
        title('Lick Bout Heat Map','fontsize',16)
        ylabel('Trial Number','fontsize',16)
        xlabel('Time from lick onset (s)','fontsize',16)
        cb = colorbar;
        %         ylabel(cb, 'dFF','fontsize',16)
        axis tight;
        onset_ind=round(1:((pretime+basetime)/(basetime+pretime+posttime)*size(allSignalsff475,2)));
        pre_ff475=allSignalsff475(:,1:onset_ind);
        post_ff475=allSignalsff475(:,onset_ind+1:end);
        pre_ff570=allSignalsff570(:,1:onset_ind);
        post_ff570=allSignalsff570(:,onset_ind+1:end);
        
        pre_ff475mean=mean(pre_ff475,2);
        post_ff475mean=mean(post_ff475,2);
        ff475mean=[mean(pre_ff475mean),mean(post_ff475mean)];
        ff475std=[std(pre_ff475mean),std(post_ff475mean)];
        
        pre_ff570mean=mean(pre_ff570,2);
        post_ff570mean=mean(post_ff570,2);
        ff570mean=[mean(pre_ff570mean),mean(post_ff570mean)];
        ff570std=[std(pre_ff570mean),std(post_ff570mean)];
        
        figure('name','Peri-mean')
        hbarff475=bar([1,2],ff475mean);
        hbarff475.FaceColor=[1 1 1];
        hold on;
        herrff475=errorbar([1,2],ff475mean,ff475std);
        herrff475.LineStyle='none';
        hold on;
        scatter(ones(size(pre_ff475mean)),pre_ff475mean);
        hold on;
        scatter(ones(size(post_ff475mean))*2,post_ff475mean);
        hold on;
        % plot([ones(size(pre_ff475mean)),ones(size(post_ff475mean))*2]',[pre_ff475mean,post_ff475mean]');
        
        plotMatrix([ones(size(pre_ff475mean)),ones(size(post_ff475mean))*2]',[pre_ff475mean,post_ff475mean]',[0,1,0]);
        
        hbarff570=bar([3,4],ff570mean);
        hbarff570.FaceColor=[1 1 1];
        hold on;
        herrff570=errorbar([3,4],ff570mean,ff570std);
        herrff570.LineStyle='none';
        hold on;
        scatter(ones(size(pre_ff570mean))*3,pre_ff570mean);
        hold on;
        scatter(ones(size(post_ff570mean))*4,post_ff570mean);
        hold on;
        % plot([ones(size(pre_ff570mean))*3,ones(size(post_ff570mean))*4]',[pre_ff570mean,post_ff570mean]');
        plotMatrix([ones(size(pre_ff570mean))*3,ones(size(post_ff570mean))*4]',[pre_ff570mean,post_ff570mean]',[1,0,1]);
        set(gca,'xtick',1:4,'XTickLabel',{'Green-Pre','Green-post','Red-Pre','Red-post'});
        ylabel('dF/F');
        set(gca,'TickDir','out');
        set(gcf,'Renderer','painters');
        
        Fiber.ff475.heatmap.value=allSignalsff475;
        Fiber.ff475.heatmap.base_time=basetime;
        Fiber.ff475.heatmap.pre_time=pretime;
        Fiber.ff475.heatmap.post_time=posttime;
        Fiber.ff475.heatmap.pre=pre_ff475mean;
        Fiber.ff475.heatmap.post=post_ff475mean;
        Fiber.ff570.heatmap.value=allSignalsff570;
        Fiber.ff475.heatmap.average=mean(Fiber.ff475.heatmap.value);
        Fiber.ff570.heatmap.average=mean(Fiber.ff570.heatmap.value);
        
        Fiber.ff570.heatmap.base_time=basetime;
        Fiber.ff570.heatmap.pre_time=pretime;
        Fiber.ff570.heatmap.post_time=posttime;
        Fiber.ff570.heatmap.pre=pre_ff570mean;
        Fiber.ff570.heatmap.post=post_ff570mean;
        
        Fiber.ff475.heatmap.xtime=linspace(-1*(Fiber.basetime+Fiber.pretime),Fiber.posttime,length(Fiber.ff475.heatmap.value))';
        Fiber.ff570.heatmap.xtime=linspace(-1*(Fiber.basetime+Fiber.pretime),Fiber.posttime,length(Fiber.ff570.heatmap.value))';
        
        [base_stim,pre_stim,post_stim,lick_matrix]=lickscore(Event.lick.level,SampleFrequency,TIMEarg,BOUT_TIME_THRESHOLD,MIN_LICK_THRESH);
        Event.lick_bouts.lick_matrix=lick_matrix;
        Event.lick_bouts.base_stim=base_stim;
        Event.lick_bouts.pre_stim=pre_stim;
        Event.lick_bouts.post_stim=post_stim;
        
        filetag=filename(1:end-4);
        %         save([pathname,filetag,'.mat'],'Event','Fiber','filename');
        
        
        if ~isempty(get(handles.edit11,'String'))
            treatment=get(handles.edit11,'String');
        else
            treatment=inputdlg('Enter treatment,e.g.saline or drug ','treatment');
            treatment=treatment{1};
        end
        
        save([pathname,filetag,'drinking',treatment,'.mat'],'Event','Fiber','filename','peri_time');
        set(handles.edit11,'String',[treatment,'done']);
        
        %% Optogenetic
    case 3
        Fiber.ff475.value=Fiber.ff475.value-Fiber.ff475.offset;
        Fiber.ff570.value=Fiber.ff570.value-Fiber.ff570.offset;
        
        BOUT_TIME_THRESHOLD = 10; % example bout time threshold, in seconds
        MIN_stimulation_THRESH = 1; % four stimulation or more make a bout
        Event.laser.level=round(Event.channel.level);
        TIMEarg=[basetime,pretime,posttime];
        
        %% laser time
        laserleveldiff=diff(Event.laser.level);
        Event.laser.on=xtime(find(laserleveldiff==1)+1);
        Event.laser.off=xtime(find(laserleveldiff==-1)+1);
        trialtotalnum=length(Event.laser.on);
        figure('name','ff475-ff570 channel');
        subplot(2,1,1)
        plot(xtime,Fiber.ff475.value,'color',colorpool.ff475);
        hold on;
        ylimrang=get(gca,'ylim');
        shiftlevel(find(Event.laser.level==0))=ylimrang(1);
        shiftlevel(find(Event.laser.level==1))=ylimrang(1)+(ylimrang(2)-ylimrang(1))*0.2;
        plot(xtime,shiftlevel,'color',colorpool.cyan);
        xlim([0,xtime(end)]);
        
        subplot(2,1,2)
        plot(xtime,Fiber.ff570.value,'color',colorpool.ff570);
        hold on;
        ylimrang=get(gca,'ylim');
        shiftlevel(find(Event.laser.level==0))=ylimrang(1);
        shiftlevel(find(Event.laser.level==1))=ylimrang(1)+(ylimrang(2)-ylimrang(1))*0.2;
        plot(xtime,shiftlevel,'color',colorpool.cyan);
        xlim([0,xtime(end)]);
        
        
        laser_on = Event.laser.on;
        laser_off = Event.laser.off;
        laser_x = reshape(kron([laser_on, laser_off], [1, 1])', [], 1);
        sz = length(laser_on);
        Event.laser.data=ones(sz,1);
        d = Event.laser.data';
        y_scale = 1; %adjust according to data needs
        y_shift = -0.20; %scale and shift are just for asthetics
        laser_y = reshape([zeros(1, sz); d; d; zeros(1, sz)], 1, []);
        
        %% Find differences in onsets and threshold for major difference indices
        laser_on_diff = diff(Event.laser.on);
        laser_diff_ind = find(laser_on_diff >= BOUT_TIME_THRESHOLD);
        
        % Make an onset/ offset array based on threshold indices
        
        diff_ind_i = 1;
        for i = 1:length(laser_diff_ind)
            % BOUT onset is thresholded onset index of laser epoc event
            Event.laser_bouts.on(i) = Event.laser.on(diff_ind_i);
            % BOUT offset is thresholded offset of laser event before next onset
            Event.laser_bouts.off(i) = Event.laser.off(laser_diff_ind(i));
            Event.laser_bouts.data(i) = 1; % set the data value, arbitrary 1
            diff_ind_i = laser_diff_ind(i) + 1; % increment the index
        end
        
        %         filetag=filename(1:end-4);
        %         save([pathname,filetag,'pushbutton2.mat'],'Event','Fiber','filename');
        
        
        % Special case for last event to handle laser event offset indexing
        Event.laser_bouts.on = [Event.laser_bouts.on,Event.laser.on(laser_diff_ind(end)+1)];
        Event.laser_bouts.off = [Event.laser_bouts.off,Event.laser.off(end)];
        Event.laser_bouts.data = [Event.laser_bouts.data, 1];
        % Transpose the arrays to make them column vectors like other epocs
        Event.laser_bouts.on = Event.laser_bouts.on';
        Event.laser_bouts.off = Event.laser_bouts.off';
        Event.laser_bouts.data = Event.laser_bouts.data';
        %%
        % Now determine if it was a 'real' bout or not by thresholding by some
        % user-set number of lasers in a row
        lasers_array = zeros(length(Event.laser_bouts.on),1);
        for i = 1:length(Event.laser_bouts.on)
            % Find number of lasers in lasers_array between onset ond offset of
            % Our new laser BOUT (laser_EVENT)
            lasers_array(i) = numel(find(Event.laser.on >=Event.laser_bouts.on(i) & Event.laser.on <=Event.laser_bouts.off(i)));
        end
        
        %%
        % Remove onsets, offsets, and data of thrown out events. Matlab can use
        % booleans for indexing. Cool!
        Event.laser_bouts.on((lasers_array < MIN_stimulation_THRESH)) = [];
        Event.laser_bouts.off((lasers_array < MIN_stimulation_THRESH)) = [];
        Event.laser_bouts.data((lasers_array < MIN_stimulation_THRESH)) = [];
        laser_EVENT_on = Event.laser_bouts.on;
        laser_EVENT_off = Event.laser_bouts.off;
        laser_EVENT_x = reshape(kron([laser_EVENT_on,laser_EVENT_off],[1, 1])',[],1);
        sz = length(laser_EVENT_on);
        d = Event.laser_bouts.data';
        laser_EVENT_y = reshape([zeros(1, sz); d; d; zeros(1, sz)], 1, []);
        
        %%
        % Next step: dFF with newly defined laser bouts
        figure('name','ff475&laser_bounts')
        subplot(2,1,1)
        p1 = plot(xtime, Fiber.ff475.value,'Color',colorpool.ff475,'LineWidth',2);
        hold on;
        title('ff475','fontsize',16);
        ylimrang=get(gca,'ylim');
        shiftlevel2(find(laser_EVENT_y==0))=ylimrang(1);
        shiftlevel2(find(laser_EVENT_y==1))=ylimrang(1)+(ylimrang(2)-ylimrang(1))*0.2;
        p2=plot(laser_EVENT_x,shiftlevel2','color',colorpool.cyan);
        xlim([0,xtime(end)]);
        legend([p1 p2],'Green', 'laser Bout');
        axis tight
        subplot(2,1,2)
        p1 = plot(xtime, Fiber.ff570.value,'Color',colorpool.ff570,'LineWidth',2);
        hold on;
        title('ff570','fontsize',16);
        ylimrang=get(gca,'ylim');
        shiftlevel2(find(laser_EVENT_y==0))=ylimrang(1);
        shiftlevel2(find(laser_EVENT_y==1))=ylimrang(1)+(ylimrang(2)-ylimrang(1))*0.2;
        p2=plot(laser_EVENT_x,shiftlevel2','color',colorpool.cyan);
        xlim([0,xtime(end)]);
        legend([p1 p2],'ff570', 'laser Bout');
        axis tight
        
        
        %%
        % Making nice area fills instead of epocs for asthetics. Newer versions of
        % Matlab can use alpha on area fills, which could be desirable
        figure('name','ff475_laser_bount_patch')
        subplot(2,1,1)
        hold on;
        dFF_min = min(Fiber.ff475.value);
        dFF_max = max(Fiber.ff475.value);
        for i = 1:numel(Event.laser_bouts.on)
            h1(i) = area([Event.laser_bouts.on(i) ...
                Event.laser_bouts.off(i)], [dFF_max dFF_max], ...
                dFF_min, 'FaceColor',colorpool.cyan,'edgecolor', 'none');
        end
        p1 = plot(xtime, Fiber.ff475.value,'Color',colorpool.ff475,'LineWidth',2);
        title('ff475_laser_bounts','fontsize',16);
        legend([p1 h1(1)],'Green', 'laser Bout');
        ylabel('uV','fontsize',16)
        xlabel('Seconds','fontsize',16);
        axis tight
        subplot(2,1,2)
        hold on;
        dFF_min = min(Fiber.ff570.value);
        dFF_max = max(Fiber.ff570.value);
        for i = 1:numel(Event.laser_bouts.on)
            h2(i) = area([Event.laser_bouts.on(i) ...
                Event.laser_bouts.off(i)], [dFF_max dFF_max], ...
                dFF_min, 'FaceColor',colorpool.cyan,'edgecolor', 'none');
        end
        p2 = plot(xtime, Fiber.ff570.value,'Color',colorpool.ff570,'LineWidth',2);
        title('ff570_laser_bounts','fontsize',16);
        legend([p2 h2(1)],'ff570', 'laser Bout');
        ylabel('uV','fontsize',16)
        xlabel('Seconds','fontsize',16);
        axis tight
        
        
        % time span for peri-event filtering, PRE and POST
        TRANGE = [-1*(pretime+basetime)*floor(SampleFrequency),-1*pretime*floor(SampleFrequency),posttime*floor(SampleFrequency)];
        
        %%
        % Pre-allocate memory
        trials = numel(Event.laser_bouts.on);
        F_snipsff475 = cell(trials,1);
        Base_snipsff475=cell(trials,1);
        F_snipsff570 = cell(trials,1);
        Base_snipsff570=cell(trials,1);
        array_ind = zeros(trials,1);
        pre_stim = zeros(trials,1);
        post_stim = zeros(trials,1);
        %%
        % Make stream snips based on trigger onset
        for i = 1:trials
            % If the bout cannot include pre-time seconds before event, make zero
            if Event.laser_bouts.on(i) < (pretime+basetime)
                F_snipsff475{i} = single(zeros(1,(TRANGE(3)-TRANGE(1))));
                continue
            else
                % Find first time index after bout onset
                array_ind(i) = find(xtime > Event.laser_bouts.on(i),1);
                % Find index corresponding to pre and post stim durations
                base_stim(i)=array_ind(i) + TRANGE(1);
                pre_stim(i) = array_ind(i) + TRANGE(2);
                post_stim(i) = array_ind(i) + TRANGE(3);
                F_snipsff475{i} = Fiber.ff475.value(base_stim(i):post_stim(i))';% from base time to post time
                Base_snipsff475{i}=Fiber.ff475.value(base_stim(i):pre_stim(i))';
                F_snipsff570{i} = Fiber.ff570.value(base_stim(i):post_stim(i))';
                Base_snipsff570{i}=Fiber.ff570.value(base_stim(i):pre_stim(i))';
            end
        end
        
        %%
        % Make all snippet cells the same size based on minimum snippet length
        minLength = min(cellfun('prodofsize', F_snipsff475));
        F_snipsff475 = cellfun(@(x) x(1:minLength), F_snipsff475, 'UniformOutput',false);
        % Convert to a matrix and get mean
        allSignalsff475 = cell2mat(F_snipsff475);
        allbaseff475=mean(cell2mat(Base_snipsff475)');
        Fiber.ff475.basevalue=allbaseff475;
        allff475std=std(cell2mat(Base_snipsff475)');
        allff475stdmatrix=repmat(allff475std',1,size(allSignalsff475,2));
        allbaseff475matrix=repmat(allbaseff475',1,size(allSignalsff475,2));
        if get(handles.radiobutton1,'value')
            allSignalsff475=(allSignalsff475-allbaseff475matrix)./allbaseff475matrix; %df/f
        elseif get(handles.radiobutton2,'value')
            SDbase=inputdlg('Enter SD base NO,e.g. 11,12,13,14,15','SDbase');
            SDbase=SDbase{1};
            SDbase=str2num(SDbase);
            if SDbase(1)==0
                allSignalsff475=(allSignalsff475-allbaseff475matrix)./allff475stdmatrix;%z-score
                SNRsd475=allff475std(end);
            else
                SNRsd475=mean(allff475std(SDbase));
                %                  allSignalsff475=(allSignalsff475-mean(allbaseff475(SDbase)))/SNRsd;
                allSignalsff475=(allSignalsff475-allbaseff475matrix)/SNRsd475;
                
            end
        end
        
        mean_allSignalsff475 = mean(allSignalsff475);
        std_allSignalsff475 = std(mean_allSignalsff475);
        
        % Make a time vector snippet for peri-events
        peri_time = (1:length(mean_allSignalsff475))/SampleFrequency - pretime;
        
        %ff570
        minLength = min(cellfun('prodofsize', F_snipsff570));
        F_snipsff570 = cellfun(@(x) x(1:minLength), F_snipsff570, 'UniformOutput',false);
        % Convert to a matrix and get mean
        allSignalsff570 = cell2mat(F_snipsff570);
        allbaseff570=mean(cell2mat(Base_snipsff570)');
        Fiber.ff570.basevalue=allbaseff570;
        allff570std=std(cell2mat(Base_snipsff570)');
        allff570stdmatrix=repmat(allff570std',1,size(allSignalsff570,2));
        allbaseff570matrix=repmat(allbaseff570',1,size(allSignalsff570,2));
        if get(handles.radiobutton1,'value')
            allSignalsff570=(allSignalsff570-allbaseff570matrix)./allbaseff570matrix;%df/f
        elseif get(handles.radiobutton2,'value')
            
            if SDbase(1)==0
                allSignalsff570=(allSignalsff570-allbaseff570matrix)./allff570stdmatrix;%z-score
                SNRsd570=allff570std(end);
            else
                
                SNRsd570=mean(allff570std(SDbase));
                %                  allSignalsff570=(allSignalsff570-mean(allbaseff475(SDbase)))/SNRsd;
                allSignalsff570=(allSignalsff570-allbaseff570matrix)/SNRsd570;
                
                
                
            end
            
            figure('name','trace z-score');
            ha = tight_subplot(3,1,[.03 .03],[.1 .01],[.1 .01]);
            axes(ha(1));
            plot(xtime/60,(Fiber.ff475.value-allbaseff475(end))/SNRsd475,'color',colorpool.ff475);
            xlim([min(xtime/60),max(xtime/60)]);
            set(gca,'TickDir','out');
            axis tight
            set(gca,'box','off','xtick',[]);
            ha(1).XAxis.Visible = 'off';
            set(gca,'box','off');
            set(gca,'color','none');
            
            axes(ha(2));
            plot(xtime/60,(Fiber.ff570.value-allbaseff570(end))/SNRsd570,'color',colorpool.ff570);
            xlim([min(xtime/60),max(xtime/60)]);
            set(gca,'TickDir','out');
            axis tight
            set(gca,'box','off','xtick',[]);
            ha(2).XAxis.Visible = 'off';
            set(gca,'box','off');
            set(gca,'color','none');
            axes(ha(3));
            plot(xtime/60,Event.channel.level,'color','k')
            xlim([min(xtime/60),max(xtime/60)]);
            set(gca,'TickDir','out');
            % axis tight
            set(gca,'box','off');
            set(gca,'color','none');
            ylim([0.2,1]);
            xlabel('Time(min)');
            set(gcf,'renderer','painters')
            filetag=filename(1:end-4);
            if ~isempty(get(handles.edit11,'String'))
                treatment=get(handles.edit11,'String');
            else
                treatment=inputdlg('Enter treatment,e.g.saline or drug ','treatment');
                treatment=treatment{1};
            end
            saveas(gcf, [pathname,filetag,treatment,'SNRfig.fig']);
            saveas(gcf, [pathname,filetag,treatment,'SNRpdf.pdf']);
          end
        mean_allSignalsff570 = mean(allSignalsff570);
        std_allSignalsff570 = std(mean_allSignalsff570);
        
        % Make a time vector snippet for peri-events
        peri_time = (1:length(mean_allSignalsff570))/SampleFrequency - (pretime+basetime);
        %% Make a Peri-Event Stimulus Plot and Heat Map
        
        % Make a standard deviation fill for mean signal
        figure('Position',[100, 100, 500, 550])
        subplot(2,2,1)
        xx = [peri_time, fliplr(peri_time)];
        yy = [mean_allSignalsff475 + std_allSignalsff475,...
            fliplr(mean_allSignalsff475 - std_allSignalsff475)];
        h = fill(xx, yy, 'g'); % plot this first for overlay purposes
        hold on;
        set(h, 'facealpha', 0.25, 'edgecolor', 'none');
        
        % Set specs for min and max value of event line.
        % Min and max of either std or one of the signal snip traces
        linemin = min(min(min(allSignalsff475)),min(yy));
        linemax = max(max(max(allSignalsff475)),max(yy));
        
        % Plot the line next
        l1 = line([0 0], [linemin, linemax],...
            'color','cyan', 'LineStyle', '-', 'LineWidth', 2);
        % Plot the signals and the mean signal
        % p1 = plot(peri_time, allSignalsff475', 'color', gray1);
        p1= plot(peri_time, allSignalsff475','color',colorpool.gray1);
        p2 = plot(peri_time, mean_allSignalsff475, 'color', colorpool.ff475, 'LineWidth', 3);
        hold off;
        
        % Make a legend and do other plot things
        legend([l1, p1(1), p2, h],...
            {'laser Onset','Trial Traces','Mean Response','Std'},...
            'Location','northeast');
        title('Peri-Event Trial Responses','fontsize',16);
        ylabel('dF/F','fontsize',16);
        xlabel('Time from laser onset (s)','fontsize',16)
        
        axis tight;
        % Make an invisible colorbar so this plot aligns with one below it
        temp_cb = colorbar('Visible', 'off');
        
        % Heat map
        subplot(2,2,2)
        imagesc(peri_time, 1, allSignalsff475); % this is the heatmap
        set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
        colormap(jet) % colormap otherwise defaults to perula
        title('laser Bout Heat Map','fontsize',16)
        ylabel('Trial Number','fontsize',16)
        xlabel('Time from laser onset (s)','fontsize',16)
        cb = colorbar;
        %         ylabel(cb, 'dFF','fontsize',16)
        axis tight;
        
        subplot(2,2,3)
        xx = [peri_time, fliplr(peri_time)];
        yy = [mean_allSignalsff570 + std_allSignalsff570,...
            fliplr(mean_allSignalsff570 - std_allSignalsff570)];
        h = fill(xx, yy, 'r'); % plot this first for overlay purposes
        hold on;
        set(h, 'facealpha', 0.25, 'edgecolor', 'none');
        
        % Set specs for min and max value of event line.
        % Min and max of either std or one of the signal snip traces
        linemin = min(min(min(allSignalsff570)),min(yy));
        linemax = max(max(max(allSignalsff570)),max(yy));
        
        % Plot the line next
        l1 = line([0 0], [linemin, linemax],...
            'color','cyan', 'LineStyle', '-', 'LineWidth', 2);
        % Plot the signals and the mean signal
        % p1 = plot(peri_time, allSignalsff570', 'color', gray1);
        
        p1=  plot(peri_time, allSignalsff570','color',colorpool.gray1);
        
        p2 = plot(peri_time, mean_allSignalsff570, 'color', colorpool.ff570, 'LineWidth', 3);
        hold off;
        
        % Make a legend and do other plot things
        legend([l1, p1(1), p2, h],...
            {'laser Onset','Trial Traces','Mean Response','Std'},...
            'Location','northeast');
        title('Peri-Event Trial Responses','fontsize',16);
        ylabel('dF/F','fontsize',16);
        xlabel('Time from laser onset (s)','fontsize',16)
        
        axis tight;
        % Make an invisible colorbar so this plot aligns with one below it
        temp_cb = colorbar('Visible', 'off');
        
        % Heat map
        subplot(2,2,4)
        imagesc(peri_time, 1, allSignalsff570); % this is the heatmap
        set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
        colormap(jet) % colormap otherwise defaults to perula
        title('laser Bout Heat Map','fontsize',16)
        ylabel('Trial Number','fontsize',16)
        xlabel('Time from laser onset (s)','fontsize',16)
        cb = colorbar;
        %         ylabel(cb, 'dFF','fontsize',16)
        axis tight;
        onset_ind=round(1:((pretime+basetime)/(basetime+pretime+posttime)*size(allSignalsff475,2)));
        pre_ff475=allSignalsff475(:,1:onset_ind);
        post_ff475=allSignalsff475(:,onset_ind+1:end);
        pre_ff570=allSignalsff570(:,1:onset_ind);
        post_ff570=allSignalsff570(:,onset_ind+1:end);
        
        pre_ff475mean=mean(pre_ff475,2);
        post_ff475mean=mean(post_ff475,2);
        ff475mean=[mean(pre_ff475mean),mean(post_ff475mean)];
        ff475std=[std(pre_ff475mean),std(post_ff475mean)];
        
        pre_ff570mean=mean(pre_ff570,2);
        post_ff570mean=mean(post_ff570,2);
        ff570mean=[mean(pre_ff570mean),mean(post_ff570mean)];
        ff570std=[std(pre_ff570mean),std(post_ff570mean)];
        
        figure('name','Peri-mean')
        hbarff475=bar([1,2],ff475mean);
        hbarff475.FaceColor=[1 1 1];
        hold on;
        herrff475=errorbar([1,2],ff475mean,ff475std);
        herrff475.LineStyle='none';
        hold on;
        scatter(ones(size(pre_ff475mean)),pre_ff475mean);
        hold on;
        scatter(ones(size(post_ff475mean))*2,post_ff475mean);
        hold on;
        % plot([ones(size(pre_ff475mean)),ones(size(post_ff475mean))*2]',[pre_ff475mean,post_ff475mean]');
        
        plotMatrix([ones(size(pre_ff475mean)),ones(size(post_ff475mean))*2]',[pre_ff475mean,post_ff475mean]',[0,1,0]);
        
        hbarff570=bar([3,4],ff570mean);
        hbarff570.FaceColor=[1 1 1];
        hold on;
        herrff570=errorbar([3,4],ff570mean,ff570std);
        herrff570.LineStyle='none';
        hold on;
        scatter(ones(size(pre_ff570mean))*3,pre_ff570mean);
        hold on;
        scatter(ones(size(post_ff570mean))*4,post_ff570mean);
        hold on;
        % plot([ones(size(pre_ff570mean))*3,ones(size(post_ff570mean))*4]',[pre_ff570mean,post_ff570mean]');
        plotMatrix([ones(size(pre_ff570mean))*3,ones(size(post_ff570mean))*4]',[pre_ff570mean,post_ff570mean]',[1,0,1]);
        set(gca,'xtick',1:4,'XTickLabel',{'Green-Pre','Green-post','Red-Pre','Red-post'});
        ylabel('dF/F');
        set(gca,'TickDir','out');
        set(gcf,'Renderer','painters');
        
        Fiber.ff475.heatmap.value=allSignalsff475;
        Fiber.ff475.heatmap.base_time=basetime;
        Fiber.ff475.heatmap.pre_time=pretime;
        Fiber.ff475.heatmap.post_time=posttime;
        Fiber.ff475.heatmap.pre=pre_ff475mean;
        Fiber.ff475.heatmap.post=post_ff475mean;
        Fiber.ff570.heatmap.value=allSignalsff570;
        Fiber.ff570.heatmap.base_time=basetime;
        Fiber.ff570.heatmap.pre_time=pretime;
        Fiber.ff570.heatmap.post_time=posttime;
        Fiber.ff570.heatmap.pre=pre_ff570mean;
        Fiber.ff570.heatmap.post=post_ff570mean;
        Fiber.ff475.heatmap.average=mean(Fiber.ff475.heatmap.value);
        Fiber.ff570.heatmap.average=mean(Fiber.ff570.heatmap.value);
        [base_stim,pre_stim,post_stim,laser_matrix]=laserscore(Event.laser.level,SampleFrequency,TIMEarg,BOUT_TIME_THRESHOLD,MIN_stimulation_THRESH);
        Event.laser_bouts.laser_matrix=laser_matrix;
        Event.laser_bouts.base_stim=base_stim;
        Event.laser_bouts.pre_stim=pre_stim;
        Event.laser_bouts.post_stim=post_stim;
        
        Fiber.ff475.heatmap.xtime=linspace(-1*(Fiber.basetime+Fiber.pretime),Fiber.posttime,length(Fiber.ff475.heatmap.value))';
        Fiber.ff570.heatmap.xtime=linspace(-1*(Fiber.basetime+Fiber.pretime),Fiber.posttime,length(Fiber.ff570.heatmap.value))';
        
        filetag=filename(1:end-4);
        if ~isempty(get(handles.edit11,'String'))
            treatment=get(handles.edit11,'String');
        else
            treatment=inputdlg('Enter treatment,e.g.saline or drug ','treatment');
            treatment=treatment{1};
        end        
        save([pathname,filetag,'_Optogenetic_',treatment,'.mat'],'Event','Fiber','filename','peri_time');
        
        set(handles.edit11,'String',[treatment,'done']);
        
        
        
        
        
end




% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
set(handles.radiobutton1,'value',1);
set(handles.radiobutton2,'value',0);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',1);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]=getlastfile('*.mat','Open Fiber results',0);
if pathname==0
    return
end
load ([pathname,filename]);
peri_time = (1:length(Fiber.ff475.heatmap.value))/Fiber.ff475.SampleFrequency - (Fiber.pretime+Fiber.basetime);
allSignalsff475=Fiber.ff475.heatmap.value;
mean_allSignalsff475 = mean(Fiber.ff475.heatmap.value);
std_allSignalsff475 = std(Fiber.ff475.heatmap.value);

allSignalsff570=Fiber.ff570.heatmap.value;
mean_allSignalsff570 = mean(Fiber.ff570.heatmap.value);
std_allSignalsff570 = std(Fiber.ff570.heatmap.value);

colorpool.ff475 = [0.2, 0.6275, 0.1725];
colorpool.ff570 = [1, 0, 0];
colorpool.cyan = [0.3010, 0.7450, 0.9330];
colorpool.gray1 = [.7 .7 .7];
colorpool.gray2 = [.8 .8 .8];

figure('Position',[100, 100, 500, 550])
subplot(2,2,1)
xx = [peri_time, fliplr(peri_time)];
yy = [mean_allSignalsff475 + std_allSignalsff475,...
    fliplr(mean_allSignalsff475 - std_allSignalsff475)];
h = fill(xx, yy, 'g'); % plot this first for overlay purposes
hold on;
set(h, 'facealpha', 0.25, 'edgecolor', 'none');

% Set specs for min and max value of event line.
% Min and max of either std or one of the signal snip traces
linemin = min(min(min(allSignalsff475)),min(yy));
linemax = max(max(max(allSignalsff475)),max(yy));

% Plot the line next
l1 = line([0 0], [linemin, linemax],...
    'color','cyan', 'LineStyle', '-', 'LineWidth', 2);
% Plot the signals and the mean signal
% p1 = plot(peri_time, allSignalsff475', 'color', gray1);
p1= plot(peri_time, allSignalsff475,'color',colorpool.gray1);
p2 = plot(peri_time, mean_allSignalsff475, 'color', colorpool.ff475, 'LineWidth', 3);
hold off;

% Make a legend and do other plot things
legend([l1, p1(1), p2, h],...
    {'Lick Onset','Trial Traces','Mean Response','Std'},...
    'Location','northeast');
title('Peri-Event Trial Responses','fontsize',16);
ylabel('dF/F','fontsize',16);
xlabel('Time from lick onset (s)','fontsize',16)

axis tight;
% Make an invisible colorbar so this plot aligns with one below it
temp_cb = colorbar('Visible', 'off');

% Heat map
subplot(2,2,2)
imagesc(peri_time, 1, Fiber.ff475.heatmap.value); % this is the heatmap
set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
colormap(jet) % colormap otherwise defaults to perula
title('Response Heatmap','fontsize',16)
ylabel('Trial Number','fontsize',16)
xlabel('Time from lick onset (s)','fontsize',16)
cb = colorbar;
axis tight;

subplot(2,2,3)
xx = [peri_time, fliplr(peri_time)];
yy = [mean_allSignalsff570 + std_allSignalsff570,...
    fliplr(mean_allSignalsff570 - std_allSignalsff570)];
h = fill(xx, yy, 'r'); % plot this first for overlay purposes
hold on;
set(h, 'facealpha', 0.25, 'edgecolor', 'none');

% Set specs for min and max value of event line.
% Min and max of either std or one of the signal snip traces
linemin = min(min(min(allSignalsff570)),min(yy));
linemax = max(max(max(allSignalsff570)),max(yy));

% Plot the line next
l1 = line([0 0], [linemin, linemax],...
    'color','cyan', 'LineStyle', '-', 'LineWidth', 2);
% Plot the signals and the mean signal
p1 = plot(peri_time, allSignalsff570, 'color', colorpool.gray1);

%         plotMatrix(peri_time, allSignalsff570',colorpool.gray1);


p2 = plot(peri_time, mean_allSignalsff570, 'color', colorpool.ff570, 'LineWidth', 3);
hold off;

% Make a legend and do other plot things
legend([l1, p1(1), p2, h],...
    {'Lick Onset','Trial Traces','Mean Response','Std'},...
    'Location','northeast');
title('Peri-Event Trial Responses','fontsize',16);
ylabel('dF/F','fontsize',16);
xlabel('Time from lick onset (s)','fontsize',16)

axis tight;
% Make an invisible colorbar so this plot aligns with one below it
temp_cb = colorbar('Visible', 'off');

% Heat map
subplot(2,2,4)
imagesc(peri_time, 1, allSignalsff570); % this is the heatmap
set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
colormap(jet) % colormap otherwise defaults to perula
title('Response Heatmap','fontsize',16)
ylabel('Trial Number','fontsize',16)
xlabel('Time from lick onset (s)','fontsize',16)
cb = colorbar;
axis tight;

pretime=Fiber.pretime;

onset_ind=round(1:((pretime+basetime)/(basetime+pretime+posttime)*size(allSignalsff475,2)));
pre_ff475=allSignalsff475(:,1:onset_ind);
post_ff475=allSignalsff475(:,onset_ind+1:end);
pre_ff570=allSignalsff570(:,1:onset_ind);
post_ff570=allSignalsff570(:,onset_ind+1:end);

pre_ff475mean=mean(pre_ff475,2);
post_ff475mean=mean(post_ff475,2);
ff475mean=[mean(pre_ff475mean),mean(post_ff475mean)];
ff475std=[std(pre_ff475mean),std(post_ff475mean)];

pre_ff570mean=mean(pre_ff570,2);
post_ff570mean=mean(post_ff570,2);
ff570mean=[mean(pre_ff570mean),mean(post_ff570mean)];
ff570std=[std(pre_ff570mean),std(post_ff570mean)];

figure('name','Peri-mean')
hbarff475=bar([1,2],ff475mean);
hbarff475.FaceColor=[1 1 1];
hold on;
herrff475=errorbar([1,2],ff475mean,ff475std);
herrff475.LineStyle='none';
hold on;
scatter(ones(size(pre_ff475mean)),pre_ff475mean);
hold on;
scatter(ones(size(post_ff475mean))*2,post_ff475mean);
hold on;
% plot([ones(size(pre_ff475mean)),ones(size(post_ff475mean))*2]',[pre_ff475mean,post_ff475mean]');

plotMatrix([ones(size(pre_ff475mean)),ones(size(post_ff475mean))*2]',[pre_ff475mean,post_ff475mean]',[0,1,0]);

hbarff570=bar([3,4],ff570mean);
hbarff570.FaceColor=[1 1 1];
hold on;
herrff570=errorbar([3,4],ff570mean,ff570std);
herrff570.LineStyle='none';
hold on;
scatter(ones(size(pre_ff570mean))*3,pre_ff570mean);
hold on;
scatter(ones(size(post_ff570mean))*4,post_ff570mean);
hold on;
% plot([ones(size(pre_ff570mean))*3,ones(size(post_ff570mean))*4]',[pre_ff570mean,post_ff570mean]');
plotMatrix([ones(size(pre_ff570mean))*3,ones(size(post_ff570mean))*4]',[pre_ff570mean,post_ff570mean]',[1,0,1]);
set(gca,'xtick',1:4,'XTickLabel',{'Green-Pre','Green-post','Red-Pre','Red-post'});
ylabel('dF/F');
set(gca,'TickDir','out');
set(gcf,'Renderer','painters');
set(handles.edit9,'String',filename);
function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileAllname, FileAllpath]=getlastfile('*.mat','Open File',1);
if FileAllpath==0
    return
end
if iscell(FileAllname)
    FileNO=length(FileAllname);
else
    FileNO=1;
    filename1=FileAllname;
    FileAllname=cell(1);
    FileAllname{1}=filename1;
end
tic
for AnimaNO=1:FileNO
    fullname=strcat(FileAllpath,FileAllname{AnimaNO});
    load (fullname);
    
    try
        Fiber.ff475.heatmap.value=Fiber.ff475.deltaFratio;
        Fiber.ff570.heatmap.value=Fiber.ff570.deltaFratio;
    catch
    end
    
    try
        Each.ff475.mean=[Each.ff475.mean;mean(Fiber.ff475.heatmap.value)];
    catch
        Each.ff475.mean=mean(Fiber.ff475.heatmap.value);
    end
    try
        total.ff475.value=[total.ff475.value;Fiber.ff475.heatmap.value];
    catch
        total.ff475.value=Fiber.ff475.heatmap.value;
    end
    try
        Each.ff570.mean=[Each.ff570.mean;mean(Fiber.ff570.heatmap.value)];
    catch
        Each.ff570.mean=mean(Fiber.ff570.heatmap.value);
    end
    try
        total.ff570.value=[total.ff570.value;Fiber.ff570.heatmap.value];
    catch
        total.ff570.value=Fiber.ff570.heatmap.value;
    end
    bountsNO(AnimaNO)=size(Fiber.ff475.heatmap.value,1);
end
peri_time = (1:length(Fiber.ff475.heatmap.value))/Fiber.ff475.SampleFrequency - (Fiber.pretime+Fiber.basetime);
colorpool.ff475 = [0.2, 0.6275, 0.1725];
colorpool.ff570 = [1, 0, 0];
colorpool.cyan = [0.3010, 0.7450, 0.9330];
colorpool.gray1 = [.7 .7 .7];
colorpool.gray2 = [.8 .8 .8];

figure('name','heatmap','Position',[100, 100, 500, 550])
subplot(2,2,1)
% ff475mean=mean(Each.ff475.mean);
% ff475std=std(Each.ff475.mean)/sqrt(FileNO);
% xx = [peri_time, fliplr(peri_time)];
% yy = [ff475mean + ff475std,fliplr(ff475mean - ff475std)];
% h = fill(xx, yy,'k'); % plot this first for overlay purposes
% set(gca,'TickDir','out');
% hold on;
% set(h, 'facealpha', 0.25, 'edgecolor', 'none');
% plot(peri_time,ff475mean,'g');

subplot(2,2,2)
imagesc(peri_time, 1, total.ff475.value); % this is the heatmap
set(gca,'YTick',[1,cumsum(bountsNO)]);
set(gca,'TickDir','out');

set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
colormap(jet) % colormap otherwise defaults to perula
title('Response Heatmap','fontsize',16)
ylabel('Trial Number','fontsize',16)
xlabel('Time from current onset (s)','fontsize',16)
cb = colorbar;
axis tight;

subplot(2,2,3)
% ff570mean=mean(Each.ff570.mean);
% ff570std=std(Each.ff570.mean)/sqrt(FileNO);
% xx = [peri_time, fliplr(peri_time)];
% yy = [ff570mean + ff570std,fliplr(ff570mean - ff570std)];
% h = fill(xx, yy,'k'); % plot this first for overlay purposes
% hold on;
% set(h, 'facealpha', 0.25, 'edgecolor', 'none');
% plot(peri_time,ff570mean,'r');
% set(gca,'TickDir','out');

subplot(2,2,4)
imagesc(peri_time, 1, total.ff570.value); % this is the heatmap
set(gca,'YTick',[1,cumsum(bountsNO)]);
set(gca,'YDir','normal') % put the trial numbers in better order on y-axis
set(gca,'TickDir','out');
colormap(jet) % colormap otherwise defaults to perula
title('Response Heatmap','fontsize',16)
ylabel('Trial Number','fontsize',16)
xlabel('Time from current onset (s)','fontsize',16)
cb = colorbar;
axis tight;
set(gcf,'Renderer','painters');

save([FileAllpath,'totalvalues.mat'],'Each','total','bountsNO','peri_time');
set(handles.edit10,'String',FileAllpath);


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
