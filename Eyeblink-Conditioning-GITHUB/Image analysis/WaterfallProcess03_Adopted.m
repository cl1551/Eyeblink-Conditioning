function funWaterfallProcess03()
clear
clc
% First please input some parameters for grouping, zero does not need to be changed.
%GroupingPlot = [132, 33, 44];
GroupingPlot = [3, 10, 3];
GroupingColor = ['k', 'k', 'k', 'k'];
%GroupingColor = ['b', 'g', 'r', 'm'];

projDirectory = 'C:\Users\LabLPM\Desktop\Eyeblink-Conditioning-GITHUB'; % change the string here as appropriate

videoDirectory = strcat(projDirectory, '\Video\Example\07-27-2022-All_Example'); % name of the directory with the videos that you want to process

dataDirectory = strcat(projDirectory, '\Data'); % name of the directory with the videos that you want to process

cd(dataDirectory);

if exist(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'file')
    load(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'EyeblinkData');
    EyeblinkData_Base0 = [EyeblinkData{1} - EyeblinkData{1}(1, 1)];
    for r = 2:1:length(EyeblinkData)
        EyeblinkData_Base0 = [EyeblinkData_Base0; EyeblinkData{r} - EyeblinkData{r}(1, 1)];
    end
    MatrixArray_X = [1:1:size(EyeblinkData_Base0, 2)];
    MatrixArray_Y = EyeblinkData_Base0(1, :);
    MatrixArray_Y2 = MatrixArray_Y;
    MatrixArray_Z = zeros(1, size(EyeblinkData_Base0, 2));
    
    Selecteds = 1;
    for i = 1:1:size(EyeblinkData_Base0, 1) - 1
        Selecteds = Selecteds + 1;
        MatrixArray_X = [MatrixArray_X; [1:1:size(EyeblinkData_Base0, 2)]]; 
        MatrixArray_Y = [MatrixArray_Y; EyeblinkData_Base0(Selecteds,:)];
        MatrixArray_Y2 = [MatrixArray_Y2; MatrixArray_Y(Selecteds, :) + (Selecteds-1)*5];
        MatrixArray_Z = [MatrixArray_Z; MatrixArray_Z(1, :)+(Selecteds-1)*100];
    end

    %% Drawing a Curve
    %figure;
    %title(strcat('Eyeblink For ', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end)));

    %hold on;

    %plot(MatrixArray_Y');

    %set(gca, 'xTickLabel',{'0','0.2','0.4','0.6','0.8', '1.0'});
    %set(gca, 'yTick', 0:10:100);
    %xlabel('Time from Tone (s)');
    %ylabel('Fraction Eyelid Closure (FEC)');

    %hold off;

    figure;

    title(strcat('Waterfall For ', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end)));

    hold on;

    %C = gradient(Z);
    %waterfall(MatrixArray_X, MatrixArray_Y2, MatrixArray_Z);
    plot(MatrixArray_Y2(GroupingPlot(1, 1)+GroupingPlot(1, 2)+GroupingPlot(1, 3) + 1:end, :)', GroupingColor(1, 4));
    plot(MatrixArray_Y2(GroupingPlot(1, 1)+GroupingPlot(1, 2)+1 : GroupingPlot(1, 1)+GroupingPlot(1, 2)+GroupingPlot(1, 3), :)', GroupingColor(1, 3));
    plot(MatrixArray_Y2(GroupingPlot(1, 1)+1 : GroupingPlot(1, 1)+GroupingPlot(1, 2), :)', GroupingColor(1, 2));
    plot(MatrixArray_Y2(1:GroupingPlot(1, 1), :)', GroupingColor(1, 1));

    
    %legend     %显示图例

    %set(gca, 'xTick', 1:50:250);
    %set(gca, 'xTickLabel',{'0','0.2','0.4','0.6','0.8', '1.0'});
    %set(gca, 'yTick', 0:10:100);
    xlabel('X -- as waterfall');
    ylabel('Y -- add a Height value for each one');
    zlabel('Z');

    hold off;
    


    else
        error(strcat('There are not the data file: ', 'V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat in Data folder.'));
    end
end