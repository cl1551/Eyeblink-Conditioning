function funVideotransfertoData(videoDirectory, dataDirectory)

%gitDirectory = 'D:\Eyeblink'; % change the string here as appropriate
%cd(gitDirectory);

%videoDirectory = strcat(gitDirectory, '\Video\06_01_2021_01-A1'); % name of the directory with the videos that you want to process
videoFiles = dir(strcat(videoDirectory, '\*.avi')); % directory with the videos that you want to process, and the name of the calibration video for this session

nameCell = cell(length(videoFiles),1);
if length(videoFiles) > 0
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
        EyeblinkData{VideoNum} = Eyeblink; %黑色像素点的占比
            if VideoNum == 1
                AvgEyeblink = EyeblinkData{VideoNum}; 
            else
                if VideoNum <= 9
                AvgEyeblink = AvgEyeblink + EyeblinkData{VideoNum};
                end
            end
        %disp(num)
        if VideoNum == 9 | (VideoNum < 9 & VideoNum == length(videoFiles))
            AvgEyeblink = AvgEyeblink / VideoNum;  %平均值作为基线
            [nummax, numaxdex] = max(AvgEyeblink);  %默认是求每一列的最大值nummax，numaxdex是每列的最大值的下标（单下标）
            [nummin, numindex] = min(AvgEyeblink);  %默认是求每一列的最小值nummin，numindex是每列最小值的下标（单下的标）
            for i = 1:1:VideoNum
                EyeblinkData{i} = funStandardization(EyeblinkData{i}, nummax, nummin);
            end
        end
        if VideoNum > 9
        EyeblinkData{VideoNum} = funStandardization(EyeblinkData{VideoNum}, nummax, nummin);
        end
    end


    cd (dataDirectory);
    save (strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end)), 'EyeblinkData');

end
end

