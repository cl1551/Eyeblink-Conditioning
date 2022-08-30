function funPlotProcess()
clear
clc
close all
projDirectory = 'C:\Users\LabLPM\Desktop\Eyeblink-Conditioning-GITHUB'; % change the string here as appropriate

videoDirectory = strcat(projDirectory, '\Video\Example\A12'); % name of the directory with the videos that you want to process

dataDirectory = strcat(projDirectory, '\Data'); % name of the directory with the videos that you want to process

cd(dataDirectory);

if ~exist(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'file')
   funVideotransfertoData(videoDirectory, dataDirectory);
end
load(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'EyeblinkData');

%% Drawing a Curve

title(strcat('Eyeblink For ', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end)));

hold on;

for i = 1:1:length(EyeblinkData)
    plot(EyeblinkData{i});
end

set(gca, 'xTickLabel',{'0','0.2','0.4','0.6','0.8', '1.0'});
xlabel('Time from Tone (s)');
ylabel('Fraction Eyelid Closure (FEC)');

hold off;

end