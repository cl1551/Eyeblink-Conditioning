function funPlotProcessFlashOnly()
clear
clc
xvariable = 0;
yvariable = 0;
for n = 1:10
projDirectory = 'C:\Users\LabLPM\Desktop\Eyeblink-Conditioning-GITHUB'; % change the string here as appropriate
xvariable = xvariable + 1;
yvariable = yvariable + 1;
x = num2str(xvariable,'%01d');
while xvariable == 3
    xvariable = 0;
end 
y = 1 + 0.1666666 * yvariable;
y = round(y,0);
y = num2str(y,'%02d');


BaseDirectory = strcat(projDirectory,'\Video\Example\' ,'A12'); % name of the directory with the videos that you want to process

videoDirectory = strcat(projDirectory,'\Video\Example\','E',x); % name of the directory with the videos that you want to process

dataDirectory = strcat(projDirectory, '\Data'); % name of the directory with the videos that you want to process

cd(dataDirectory);

if ~exist(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'file')
    try
   funVideotransfertoDataFlashOnly(BaseDirectory, videoDirectory, dataDirectory);
    end
end
try
load(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'EyeblinkData');
catch
end
end
end