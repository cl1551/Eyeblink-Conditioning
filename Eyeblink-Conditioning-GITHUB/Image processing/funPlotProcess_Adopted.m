function funPlotProcess_Adopted(videoDirectory)
projDirectory = 'C:\Users\LabLPM\Desktop\Eyeblink-Conditioning-GITHUB'; % change the string here as appropriate

dataDirectory = strcat(projDirectory, '\Data'); % name of the directory with the videos that you want to process

cd(dataDirectory);

if ~exist(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'file')
   funVideotransfertoData(videoDirectory, dataDirectory);
   
end
try
load(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'EyeblinkData');
catch
end
