function funVideotransfertoDataFlashOnly(vBaseDirectory, vvideoDirectory, vdataDirectory)

BaseFiles = dir(strcat(vBaseDirectory, '\*.avi'));

nameBaseCell = cell(length(BaseFiles), 1);

for i = 1:length(BaseFiles)
    % disp(videoFiles(i).name)
    nameBaseCell{i} = BaseFiles(i).name;
end

BaseName = funFileSort(nameBaseCell);

for AvgVideoNum = 1:9
    % disp(videoFiles(i).name)
    
    Basevideo = VideoReader(strcat(BaseFiles(AvgVideoNum).folder, '\',  BaseName{AvgVideoNum}));  %(strcat(videoFiles(VideoNum).folder, '\', VideoName(VideoNum)));
    BaseEyeblink = funVideoProcess(Basevideo);
    BaseEyeblinkData{AvgVideoNum} = BaseEyeblink; 

    if AvgVideoNum == 1
        BaseAvgEyeblink = BaseEyeblinkData{AvgVideoNum}; 
    else
        if AvgVideoNum <= 9
        BaseAvgEyeblink = BaseAvgEyeblink + BaseEyeblinkData{AvgVideoNum};
        end
    end
    %disp(num)
    if AvgVideoNum == 9 | (AvgVideoNum < 9 & AvgVideoNum == length(BaseFiles))
        BaseAvgEyeblink = BaseAvgEyeblink / AvgVideoNum;  
        [nummax, numaxdex] = max(BaseAvgEyeblink);  
        [nummin, numindex] = min(BaseAvgEyeblink); 
    end
end

videoFiles = dir(strcat(vvideoDirectory, '\*.avi')); % directory with the videos that you want to process, and the name of the calibration video for this session

nameCell = cell(length(videoFiles), 1);
for i = 1:length(videoFiles)
    % disp(videoFiles(i).name)
    nameCell{i} = videoFiles(i).name;
end
VideoName = funFileSort(nameCell);
% disp(VideoName);
for VideoNum = 1:1:length(videoFiles)
    %disp(strcat(videoFiles(VideoNum).folder, '\', VideoName{VideoNum}));
    video = VideoReader(strcat(videoFiles(VideoNum).folder, '\',  VideoName{VideoNum}));  %(strcat(videoFiles(VideoNum).folder, '\', VideoName(VideoNum)));
    Eyeblink = funVideoProcess(video);
    EyeblinkData{VideoNum} = Eyeblink;
    EyeblinkData{VideoNum} = funStandardization(EyeblinkData{VideoNum}, nummax, nummin);
end


cd (vdataDirectory);
save (strcat('V_', vvideoDirectory(max(findstr(vvideoDirectory, '\')) + 1:end)), 'EyeblinkData');

end

