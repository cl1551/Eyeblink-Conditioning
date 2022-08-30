function funLearningAbility_v03()
    clear
    clc

    projDirectory = 'C:\Users\LabLPM\Desktop\Eyeblink-Conditioning-GITHUB'; % change the string here as appropriate
    videoDirectory = strcat(projDirectory, '\Video\Example\07-27-2022-All_Example'); % name of the directory with the videos that you want to process
    dataDirectory = strcat(projDirectory, '\Data'); % name of the directory with the videos that you want to process
    cd(dataDirectory);

    if exist(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'file')
        load(strcat('V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat'), 'EyeblinkData');
        h = 5;
        for i = 1:1:length(EyeblinkData)
            BeforeFlash(i) = mean(EyeblinkData{i}(1:round(250*100/1000)));
            AfterFlash(i) = mean(EyeblinkData{i}(round(250*140/1000):round(250*448/1000)));
            Diffflash(i) = AfterFlash(i) - BeforeFlash(i);
            
            for j = round(250*420/1000):1:(round(250*840/1000) - 1)   % For Puff
                if mod(j, 10) ~= 0 & (EyeblinkData{i}(j) - mean(EyeblinkData{i}((round(250*100/1000) - 5):round(250*100/1000)))) > 65    
                    flashTime(1, i) = j;
                    break;
                else
                    flashTime(1, i) = 0;
                end
            end
            for j = (round(250*100/1000) + 1):1:(round(210*420/1000) - 1) % For Flash%%%%CHANGE FROM 250 TO 210 TO EXCLUDE BLACK WHITE CHANGE CAUSED BY FLASH LIGHT DOT%%%
                if (EyeblinkData{i}(j) - mean(EyeblinkData{i}((round(250*100/1000) - 5):round(250*100/1000)))) > 10    %差分值;
                    flashTime(2, i) = j;
                    break;
                else
                    flashTime(2, i) = 0;
                end
            end
            if mod(i, 10) == 0
                Diffflashonly(i/10) = max(EyeblinkData{i}) - mean(EyeblinkData{i}((round(250*100/1000) - 5):round(250*100/1000)));    %差分值;
            end
        end
        %% Naturalization
        
        cd (dataDirectory);
        save (strcat('A_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end)), 'Diffflashonly');
        
        figure
        bar(flashTime(2, :), 'k');
        hold on;
        plot([1, length(flashTime)], [round(250*100/1000), round(250*100/1000)], 'b');
        hold on;
        plot([1, length(flashTime)], [round(250*420/1000), round(250*420/1000)], 'y');
 
        title(strcat('Learning Ability: ', num2str(100*length(nonzeros(flashTime(2, :)))/length(flashTime(2, :))), '% For ', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end)));
        %legend     
        %set(gca, 'xTick', 1:50:250);
        set(gca, 'yTickLabel',{'0','100','200','300','400', '500', '600', '700', '800', '900', '1000'});
        %set(gca, 'yTick', 0:10:100);
        xlabel('Cycling Times');
        ylabel('Time of Each Cycle (1000ms)');

        hold off;
 
        figure
        bar(Diffflashonly, 'r');
        hold on;

        title(strcat('Flash Only ', ' For ', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end))); 
 
        %legend     
        %set(gca, 'xTick', 1:50:250);
        set(gca, 'yTickLabel',{'0','10','20','30','40', '50', '60', '70', '80', '90', '100'});
        %set(gca, 'yTick', 0:10:100);
        xlabel('Cycling Times');
        ylabel('Fraction Max Eyelid Closure');

        hold off;
        
    else
        error(strcat('There are not the data file: ', 'V_', videoDirectory(max(findstr(videoDirectory, '\')) + 1:end), '.mat in Data folder.'));
    end

end