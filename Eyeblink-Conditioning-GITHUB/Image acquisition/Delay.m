function EBAOnline_main_v2_Delay()

clear all;
fclose('all');
clc


try
    sectionNum = 1;
    h_Main.h_Video = videoinput('gige', 1, 'Mono8');%Camera used to collect videos
    h_Main.h_Arduino = arduino('COM3','UNO');%Arduino connection
    
    pause(1)    
catch
    return;
end
%% Initialization
h_Main.s_Fs = 250; % Frame per second of the acquisition
h_Main.h_src.AcquisitionFrameRate = h_Main.s_Fs;   
h_Main.s_Epochs = 110; % Number of trials
h_Main.s_LengthVideo = 5; 
h_Main.h_Video.FramesPerTrigger = h_Main.s_LengthVideo*h_Main.s_Fs;
h_Main.h_Video.ROIPositio = [300 110 248 179]%ROI of the video capture
h_Main.v_OriginalSize = h_Main.h_Video.ROIPosition;
h_Main.src = getselectedsource(h_Main.h_Video);


h_Main.s_Idx = 0;
h_Main.s_IdxTime = 0;

vidRes = h_Main.h_Video.VideoResolution;
nBands = h_Main.h_Video.NumberOfBands;

h_Main.vidFrame = [];

%% Main Figure and axes
h_Main.h_Figure = figure('Units','Normalized','Position',[.25 .2 .5 .65],...
    'Color','w','Name','EBA','MenuBar', 'none','ToolBar', 'none');

%% Set menu callbacks
% h_Main.h_Figure.CloseRequestFcn = @f_CloseFigure;

%% Axes
% For the video
h_Main.h_AxVideo = axes('Parent',h_Main.h_Figure,...
    'Units','Normalized','Position',[.1 .2 .8 .75],...
    'xTick',[],'yTick',[]);
set(h_Main.h_AxVideo,'Units','pixels');
h_Main.resizePos = round(get(h_Main.h_AxVideo,'Position'));
h_Main.h_Image   = image( ones(h_Main.resizePos(3), h_Main.resizePos(3), nBands),'Parent', h_Main.h_AxVideo);
set(h_Main.h_AxVideo,'xTick',[],'yTick',[])


h_Main.h_Preview = uicontrol('String', 'Start Preview',...
    'Callback', @startpreview_Callback,...
    'Units','normalized',...
    'Position',[.05 .1 0.2 .05]);

h_Main.h_SelArea = uicontrol('String', 'Select area',...
    'Callback',@f_SelArea,...
    'Units','normalized',...
    'Position',[.3 .1 0.2 .05],...
    'Enable','on');

h_Main.h_SingleStm = uicontrol('String', 'Single stimulation',...
    'Callback',@f_SingleStim,...
    'Units','normalized',...
    'Position',[.55 .1 0.2 .05],...
    'Enable','off');

h_Main.h_StartProtocol = uicontrol('String', 'Stim. Protocol',...
    'Callback',@f_SpecificProtocol,...
    'Units','normalized',...
    'Position',[.05 .03 0.2 .05],...
    'Enable','on');

%% Functions
    function f_EnableButtons()
                            
        h_Main.h_SelArea.Enable = 'on'; 
        h_Main.h_SingleStm.Enable = 'on';        
        %h_Main.h_StartProtocol.Enable = 'on';
    end

    function f_DisableButtons()
        h_Main.h_SingleStm.Enable = 'off';
%         h_Main.h_StartProtocol.Enable = 'off';
        h_Main.h_SelArea.Enable = 'off';
    end

    function f_SingleStim(~,~)
        funFlashPuff();
    end

    
    function funFlashPuff()
        pause(.1);
        writeDigitalPin(h_Main.h_Arduino,'D11',1); %TTL for Bonsai to detect
        writeDigitalPin(h_Main.h_Arduino,'D3',1);   % Any stimulus connected to the Arduino D3 pin. For us it's the blue LED
        pause(.32);
        if sectionNum < 10
            writeDigitalPin(h_Main.h_Arduino,'D9',1);   % Air Puff.
            sectionNum = sectionNum + 1;
        else
            sectionNum = 1;
        end
        pause(.03);
        writeDigitalPin(h_Main.h_Arduino,'D11',0);
        writeDigitalPin(h_Main.h_Arduino,'D3',0); % Any stimulus connected to the Arduino D3 pin. For us it's the blue LED
        writeDigitalPin(h_Main.h_Arduino,'D9',0);

    end

    function f_SelArea(~,~)
        set(h_Main.h_Preview,'String','Start Preview');
        stoppreview(h_Main.h_Video);
        f_DisableButtons();
        h_Main.h_Video.ROIPosition = h_Main.v_OriginalSize;
        h_Main.vidFrame = getsnapshot(h_Main.h_Video);
        h_Main.h_Image.CData  = h_Main.vidFrame;

        h_rect = imrect(h_Main.h_AxVideo); % Rectangle position is given as [xmin, ymin, width, height]
        h_Main.pos_rect = round(h_rect.getPosition);
        h_Main.h_Video.ROIPosition = h_Main.pos_rect;
        f_EnableButtons();        
        delete(h_rect);
        set(h_Main.h_Preview,'String','Stop Preview')
        preview(h_Main.h_Video, h_Main.h_Image);
        axis image
    end

    function startpreview_Callback(~,~)

        if strcmp(get(h_Main.h_Preview,'String'),'Start Preview')
            set(h_Main.h_Preview,'String','Stop Preview')
            preview(h_Main.h_Video, h_Main.h_Image);
            axis image
            %fpsdisp is a static text box. 
            %set(handles.fpsdisp,'String', num2str(vid.FramesPerTrigger));
        else
            %Camera is on. Stop camera and change button string.
            set(h_Main.h_Preview,'String','Start Preview');
            stoppreview(h_Main.h_Video);
        end

    end

    function f_SpecificProtocol(~,~)
        f_DisableButtons();
        tr_NameForProt = inputdlg('Name of protocol Video:');
        str_NameForProt = tr_NameForProt{1};
        set(h_Main.h_Preview,'String','Start Preview');
        
        
        s_Lenght = (h_Main.s_LengthVideo*h_Main.s_Fs);
        m_X = nan(s_Lenght,h_Main.s_Epochs);
        m_Y = nan(s_Lenght,h_Main.s_Epochs);
        m_S = nan(s_Lenght,h_Main.s_Epochs);
        m_AllImages = cell(h_Main.s_Epochs);
        
        
        h_Main.h_Video.FramesPerTrigger = 250;
        
        src.AcquisitionFrameRateEnable = 'True';
        src.AcquisitionFrameRate = 250;
        
        for idx = 1:h_Main.s_Epochs
            st_StopWatch = tic;            
            start(h_Main.h_Video);
            f_SingleStim();
            while 1
                if toc(st_StopWatch)>= 2    % Original is 1.5
                    break;
                end                
            end
            disp(['Saving video ',num2str(idx)])
            diskLogger = VideoWriter([str_NameForProt,'_',num2str(idx),'.avi'], 'Grayscale AVI');
            diskLogger.FrameRate = 250;

            open(diskLogger);
            data = getdata(h_Main.h_Video, h_Main.h_Video.FramesAvailable);
            numFrames = size(data, 4);
            for ii = 1:numFrames
                writeVideo(diskLogger, data(:,:,:,ii));
            end
            close(diskLogger);

            flushdata(h_Main.h_Video);
            
            while 1
                if toc(st_StopWatch)>= round(15 + (20 - 15)* rand())    % Original is 15. Now change to random space of clips.   
                    break;
                end                
            end
            
        end
        % Saving videos    
        
%         save([str_NameForProt,'.mat'],'m_X','m_Y','m_S')
        f_EnableButtons();
        waitfor(msgbox('Protocol finished'));
        set(h_Main.h_Preview,'String','Stop Preview')
        preview(h_Main.h_Video, h_Main.h_Image);
        axis image
    end
end