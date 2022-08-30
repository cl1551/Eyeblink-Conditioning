function funBatchvideo()
    clc;
    clear all;

    projDirectory = 'C:\Users\LabLPM\Desktop\Eyeblink-Conditioning-GITHUB'; % change the string here as appropriate

    dataDirectory = strcat(projDirectory, '\Data'); % name of the directory with the videos that you want to process

    mainvideoDir = strcat(projDirectory, '\Video');

    sub1Dir = dir(mainvideoDir); 
    
    existedAVI1 = 1;
    for i = 1:length(sub1Dir)    
        if (isequal(sub1Dir(i).name, '.')||isequal(sub1Dir(i).name, '..')||~sub1Dir(i).isdir)
            if (size(sub1Dir(i).name, 1) >= 3 && sub1Dir(i).name(size(sub1Dir(i).name, 1) - 4 +1:end) == '.avi' && existedAVI1 == 1)
                existedAVI1 = 0;
                funPlotProcess_Adopted(sub1Dir(i).folder);
            end
            continue;   
        end
        existedAVI2 = 1;
        sub2Dir = dir(strcat(sub1Dir(i).folder, '\', sub1Dir(i).name)); 
        for j = 1:length(sub2Dir)
            if (isequal(sub2Dir(j).name, '.')||isequal(sub2Dir(j).name, '..')||~sub2Dir(j).isdir)
                if (size(sub2Dir(j).name, 1) >= 3 && sub2Dir(j).name(size(sub2Dir(j).name, 1) - 4 +1:end) == '.avi' && existedAVI2 == 1)
                     existedAVI2 = 0;
                     funPlotProcess_Adopted(sub2Dir(j).folder);
                end
                continue;   
            end
            sub3Dir = dir(strcat(sub2Dir(j).folder, '\', sub2Dir(j).name));  
            if (length(sub3Dir) > 2)
                videoDirectory = strcat(sub2Dir(j).folder, '\', sub2Dir(j).name);
                funPlotProcess_Adopted(videoDirectory);
            end
        end
    end
end