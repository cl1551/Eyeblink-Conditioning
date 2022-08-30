function Eyeblink = funVideoProcess(videoClip)
% TRIALS=processConditioningTrials(FOLDER,CALIB,{MAXFRAMES})
% Return trials structure containing eyelid data and trial parameters for all trials in a session
% Specify either filename of trial to use for calibration or "calib" structure containing pre-calculated scale and offset.
% Optionally, specify threshold for binary image and maximum number of video frames per trial to use for extracting eyelid trace


%if length(varargin) > 0
	%thresh=varargin{1};
%end

% Error checking
%if isstruct(calib)
	%if ~isfield(calib,'scale') || ~isfield(calib,'offset')
		%error('You must specify a valid calibration structure or file from which the structure can be computed')
	%end
%elseif exist(calib,'file')
	%[data,metadata]=loadCompressed(calib);
	%if ~exist('thresh')
		%thresh=metadata.cam.thresh;
	%end
	%[y,t]=vid2eyetrace(data,metadata,thresh,5);
	%calib=getcalib(y);
%else
	%error('You must specify a valid calibration structure or file from which the structure can be computed')
%end

% By now we should have a valid calib structure to use for calibrating all files

%if ~exist(folder,'dir')
	%error('The directory you specified (%s) does not exist',folder);
%end

FramesClip = videoClip.NumberOfFrame;   % 获取视频总帧数

for frameNum = 1:1:FramesClip
    frameImage = read(videoClip,frameNum);           % 获取视频帧图像
    %imshow(frameImage);
    %disp('number of frame : '); frameNum    % 显示当前的读取帧数
    
    % 保存某一幁图片
    %if frameNum == 79
        %SaveName = strcat(videoDirectory, '\Save', num2str(frameNum), '.png');
        %imwrite(frame, SaveName);
    %end
    
    %imshow(frameImage);
    %imtool(frameImage);
    %imshow(frameimage);
    bw_img = frameImage > 200; %60; %112.5;   %35
    %figure, imshow(bw_img);
    %bw_img2 = imfill(bw_img, 'holes');
    %figure, imshow(bw_img2);
    SE = strel('disk', 5);
    % bw_img3 = imerode(bw_img, SE);
    bw_img3 = imdilate(bw_img, SE);
    %figure, imshow(bw_img3);
    %if BaseAvg < 2
    Eyeblink(frameNum) = (1 - length(find(bw_img3(:)==0))/length(bw_img3(:))) * 100; %黑色像素点的占比%Chang
    %else   %对于第一片段以后的Base视频累加黑色像素点占比，为计算平均值准备
        %bnum(frameNum) = bnum(frameNum) + (1 - length(find(bw_img3(:)==0))/length(bw_img3(:))) * 100; %黑色像素点的占比
    %end
    %disp(num)

end